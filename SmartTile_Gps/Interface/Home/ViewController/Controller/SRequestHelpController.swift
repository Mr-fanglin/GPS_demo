//
//  SRequestHelpController.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/9/1.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit


@objc protocol SRequestHelpControllerDelegate : NSObjectProtocol {
    @objc optional func sendOrderRequestSuccess(childId:Int32)
    
}
///请求接送界面
class SRequestHelpController: SBaseController {
    
    weak var delegate: SRequestHelpControllerDelegate?
    
    var childAnnotation = MAPointAnnotation()  //小孩当前位置
    var childLocationCoordinate = CLLocationCoordinate2D() {
        didSet{
            startLocationCoordinate = childLocationCoordinate
        }
    } //经纬度
    var childModel:ChildStatusModel = ChildStatusModel()
    
    var startAnnotation = MAPointAnnotation() //小孩送达位置
    var startLocationCoordinate = CLLocationCoordinate2D()  //开始经纬度
    var endAnnotation = MAPointAnnotation() //小孩送达位置
    var endLocationCoordinate = CLLocationCoordinate2D()  //结束经纬度
    
    var mapView:MAMapView?
    
    var addressView = SRAddressView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH-CGFloat(30*IPONE_SCALE), height: CGFloat(124*IPONE_SCALE)))

    //是否可以改变开始位置
    var isChangeStart:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        
        self.setInterface()
        self.setBlock()
        self.requestData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AMapLocationHelper.shared().delegate = self
    }
    
    func requestData() {
        HomeRequestObject.shared.requestChildStatus(childId: childModel.child.id) { [weak self](model) in
            if let weakself = self {
                weakself.childModel = model
                weakself.childLocationCoordinate = AMapCoordinateConvert(CLLocationCoordinate2D(latitude: model.device.latitude, longitude: model.device.longitude), AMapCoordinateType.GPS)
                weakself.setCenterPoint()
                weakself.showMapStartPoint()
            }
        }
    }
    
    func setInterface() {
        self.createNavbar(navTitle: NSLocalizedString("Pickup_request", comment: ""), leftImage: nil, rightStr: nil, ringhtAction: nil)
    
        mapView = MAMapView.init(frame: CGRect.init(x: 0, y: NEWNAVHEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-NEWNAVHEIGHT))
        mapView?.showsUserLocation = false
        mapView?.userTrackingMode = .none
        mapView?.mapType = MAMapType.standard
        mapView?.showsScale = true
        mapView?.showsCompass = true
        mapView?.setZoomLevel(16, animated: false)
        mapView?.showsWorldMap = 1
        mapView?.delegate = self
        self.view.addSubview(mapView!)
        mapView?.snp.makeConstraints({ (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(NEWNAVHEIGHT)
            make.bottom.equalToSuperview()
        })
//        AMapLocationHelper.shared().loadLocationMapData(mapView: mapView)
        mapView?.performSelector(inBackground: NSSelectorFromString("setMapLanguage:"), with: currentLocale == "zh_CN" ? 0:1)
        
        addressView.layer.cornerRadius = 10
        addressView.layer.masksToBounds = true
        self.view.addSubview(addressView)
        addressView.snp.makeConstraints { (make) in
            make.left.equalTo(15*IPONE_SCALE)
            make.right.equalTo(-15*IPONE_SCALE)
            make.bottom.equalTo(-(CGFloat(10*IPONE_SCALE)+IPHONEX_BH))
            make.height.equalTo(124*IPONE_SCALE)
        }
        
    }
    
    func setBlock() {
        addressView.stopLabelActionBlock = {[weak self]() in
            if let weakself = self {
                let searchVC = SSearchLocationController()
                searchVC.delegate = weakself as? SSearchLocationControllerDelegate
                weakself.navigationController?.pushViewController(searchVC, animated: true)
            }
        }
        
        addressView.cancelBtnActionBlock = {[weak self]() in
            if let weakself = self {
                weakself.addressView.stopTF.text = ""
                weakself.addressView.snp.updateConstraints { (make) in
                    make.height.equalTo(124*IPONE_SCALE)
                }
                weakself.mapView?.removeAnnotations([weakself.startAnnotation,weakself.endAnnotation])
                weakself.setCenterPoint()
                weakself.showMapStartPoint()
                weakself.mapView?.setZoomLevel(16, animated: false)
                weakself.isChangeStart = true
            }
        }
        
        addressView.confirmBtnActionBlock = {[weak self]() in
            if let weakself = self {
                weakself.view.makeToastActivity(.center)
                HomeRequestObject.shared.requestCreateOrder(childId: weakself.childModel.child.id, fromLatitude: weakself.childLocationCoordinate.latitude, fromLongitude: weakself.childLocationCoordinate.longitude, toLatitude: weakself.endLocationCoordinate.latitude, toLongitude: weakself.endLocationCoordinate.longitude) { (code) in
                    weakself.view.hideToastActivity()
                    if code == "0" {
                        weakself.view.makeToast(NSLocalizedString("Order_sent_successfully", comment: ""), duration: 1.0, position: .center)
                        weakself.navigationController?.popViewController(animated: true)
                        weakself.delegate?.sendOrderRequestSuccess?(childId: weakself.childModel.child.id)
                    }
                }
            }
        }
    }
}

//设置地图位置点
extension SRequestHelpController {
    func showMapStartPoint() {
        mapView?.setCenter(self.childLocationCoordinate, animated: true)
        //加载动画
        self.view.makeToastActivity(.center)
        AMapLocationHelper.shared().setMapReGeocodeSearchRequest(latitude: childLocationCoordinate.latitude, longitude: childLocationCoordinate.longitude)
    }
    
    func setCenterPoint() {
        childAnnotation.coordinate = self.childLocationCoordinate
        childAnnotation.isLockedToScreen = true
        childAnnotation.lockedScreenPoint = CGPoint.init(x: mapView?.centerX ?? CGPoint.init().x, y: (mapView?.centerY ?? CGPoint.init().y)-TabbarHeight)
        childAnnotation.title = NSLocalizedString("Boarding_position", comment: "")
        childAnnotation.subtitle = ""
        self.mapView?.addAnnotation(childAnnotation)
    }
    
    func setStartPoint() {
        startAnnotation.coordinate = self.startLocationCoordinate
        startAnnotation.title = NSLocalizedString("Boarding_position", comment: "")
        startAnnotation.subtitle = ""
        self.mapView?.addAnnotation(startAnnotation)
    }
    
    func setEndPoint() {
        endAnnotation.coordinate = self.endLocationCoordinate
        endAnnotation.title = NSLocalizedString("Delivery_location", comment: "")
        endAnnotation.subtitle = ""
        self.mapView?.addAnnotation(endAnnotation)
    }
}
