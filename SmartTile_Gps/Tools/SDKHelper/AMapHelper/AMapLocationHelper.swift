//
//  AMapLocationHelper.swift
//  XinChat
//
//  Created by FangLin on 2019/11/13.
//  Copyright © 2019 FangLin. All rights reserved.
//

/*
 * @brief
 * 高德地图定位helper类
 */
import UIKit

let AMapAppKey = "f9d3522da85d4b00095d6c248a7f0ee4"

@objc protocol AMapReGeocodeSearchDelegate : NSObjectProtocol {
    @objc optional func onReGeocodeSearchFinish(request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!)
    @objc optional func onPOISearchFinish(request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!)
    @objc optional func amapLocationManagerdidUpdatelocation(location: CLLocation!)
}

class AMapLocationHelper: NSObject {
    
    weak var delegate: AMapReGeocodeSearchDelegate?
    
    private static var _sharedInstance: AMapLocationHelper?
    /// 单例
    ///
    /// - Returns: 单例对象
    class func shared() -> AMapLocationHelper {
        guard let instance = _sharedInstance else {
            _sharedInstance = AMapLocationHelper()
            return _sharedInstance!
        }
        return instance
    }
    
    /// 销毁单例
    class func destroy() {
        _sharedInstance = nil
    }
    
    var locationManager:AMapLocationManager = AMapLocationManager.init()
    var searchManager:AMapSearchAPI = AMapSearchAPI.init()
    var amapDriveManager:AMapNaviDriveManager = AMapNaviDriveManager.sharedInstance()
    
    
    ///初始化
    func initAMapLocation() {
        AMapServices.shared().apiKey = AMapAppKey
        AMapServices.shared()?.enableHTTPS = true
        AMapLocationHelper.shared().locationManager.delegate = AMapLocationHelper.shared()
        AMapLocationHelper.shared().searchManager.delegate = AMapLocationHelper.shared()
        //设置定位最小更新距离
//        AMapLocationHelper.shared().locationManager.distanceFilter = 10
        //设置期望定位精度
        AMapLocationHelper.shared().locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        AMapLocationHelper.shared().locationManager.locationTimeout = 5
        AMapLocationHelper.shared().locationManager.reGeocodeTimeout = 5
        if IOS_VERSION >= 9 {
            AMapLocationHelper.shared().locationManager.allowsBackgroundLocationUpdates = true
        }
        AMapLocationHelper.shared().locationManager.locatingWithReGeocode = true
        AMapLocationHelper.shared().locationManager.pausesLocationUpdatesAutomatically = true
        AMapLocationHelper.shared().startUpdatingLocation()
    }
    
    func startUpdatingLocation() {
        AMapLocationHelper.shared().locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        AMapLocationHelper.shared().locationManager.stopUpdatingLocation()
    }
    
    //加载本地地图样式文件
    func loadLocationMapData(mapView:MAMapView?) {
        var path = Bundle.main.bundlePath
        path.append("/style.data")
        let data = NSData.init(contentsOfFile: path)
        let options = MAMapCustomStyleOptions.init()
        options.styleData = data! as Data
        mapView?.setCustomMapStyleOptions(options)
        mapView?.customMapStyleEnabled = true
    }
    
    ///获取单次定位
    func getOneAMapLocation(completion: @escaping (_ location:CLLocation, _ regeocode:AMapLocationReGeocode)->()) {
        if CLLocationManager.locationServicesEnabled() {
            let authStatus = CLLocationManager.authorizationStatus()
            if authStatus == .restricted || authStatus == .denied {  //被限制被拒绝
                let alertCtr = UIAlertController.initAlertView(title: "定位服务未开启", message: "请在手机设置中开启定位服务以看到附近用户", sureTitle: "开启定位") { (alert) in
                    
                    guard let url = URL.init(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.openURL(url)
                    }
                }
                UIViewController.getCurrentViewCtrl().present(alertCtr, animated: true, completion: nil)
            }else {
                AMapLocationHelper.shared().locationManager.requestLocation(withReGeocode: true) { (location, reGeocode, error) in
                    if let error = error {
                        let error = error as NSError
                        
                        if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                            //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
                            NSLog("定位错误:{\(error.code) - \(error.localizedDescription)};")
                            return
                        }else if error.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
                            || error.code == AMapLocationErrorCode.timeOut.rawValue
                            || error.code == AMapLocationErrorCode.cannotFindHost.rawValue
                            || error.code == AMapLocationErrorCode.badURL.rawValue
                            || error.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
                            || error.code == AMapLocationErrorCode.cannotConnectToHost.rawValue {
                            //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
                            NSLog("逆地理错误:{\(error.code) - \(error.localizedDescription)};")
                        }else {
                            //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
                        }
                    }
                    if let location = location,let reGeocode = reGeocode {
                        NSLog("location:%@", location)
                        NSLog("reGeocode:%@", reGeocode)
                        completion(location,reGeocode)
                    }
                }
            }
        }else {
            let alertCtr = UIAlertController.initAlertView(title: "定位服务未开启", message: "请在手机设置->隐私中开启定位服务", cancleTitle: "确定")
            UIViewController.getCurrentViewCtrl().present(alertCtr, animated: true, completion: nil)
        }
    }
}

extension AMapLocationHelper: AMapLocationManagerDelegate {
    func amapLocationManager(_ manager: AMapLocationManager!, doRequireLocationAuth locationManager: CLLocationManager!) {
        locationManager.requestAlwaysAuthorization()
    }
    
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!, reGeocode: AMapLocationReGeocode!) {
        SMainBoardObject.shared().currentLocation = location.coordinate
        if SMainBoardObject.shared().isMqttConnect {
            let gpsDict = ["latitude":SMainBoardObject.shared().currentLocation.latitude,"longitude":SMainBoardObject.shared().currentLocation.longitude,"time":Date.currentTime()] as [String : Any]
            MQTTHelper.shared().mqtt!.publish("user/gps/\(SMainBoardObject.shared().idAccount)", withString: MQTTHelper.shared().convertDictionaryToJSONString(dict: gpsDict))
//            NSLog("location:{lat:\(location.coordinate.latitude); lon:\(location.coordinate.longitude); accuracy:\(location.horizontalAccuracy)};");
        }
        delegate?.amapLocationManagerdidUpdatelocation?(location: location)
    }
    
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate newHeading: CLHeading!) {
        Dprint("----设备方向改变----")
    }
}

/// POI搜索请求
extension AMapLocationHelper {
    //逆地理编码请求
    func setMapReGeocodeSearchRequest(latitude:Double, longitude:Double) {
        let request = AMapReGeocodeSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(latitude), longitude: CGFloat(longitude))
        request.requireExtension = true
        searchManager.aMapReGoecodeSearch(request)
    }
    
    //POI周边搜索请求
    func setMapPOIAroundSearchRequest(latitude:Double, longitude:Double) {
        let request = AMapPOIAroundSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(latitude), longitude: CGFloat(longitude))
        request.sortrule = 0
        request.offset = 50
        request.requireExtension = true
        searchManager.aMapPOIAroundSearch(request)
    }
    
    //POI关键字检索
    func setMapPOIKeywordsSearchRequest(keyword:String) {
        let request = AMapPOIKeywordsSearchRequest()
        request.keywords = keyword
        request.requireExtension = true
        request.cityLimit = true
        request.requireSubPOIs = true
        searchManager.aMapPOIKeywordsSearch(request)
    }
}

extension AMapLocationHelper: AMapSearchDelegate {
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        if response.regeocode == nil {
            return
        }
        delegate?.onReGeocodeSearchFinish?(request: request, response: response)
    }
    
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        delegate?.onPOISearchFinish?(request: request, response: response)
    }
    
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        Dprint(error)
    }
}
