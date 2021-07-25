//
//  XCMsgLocationController+Delegate.swift
//  XinChat
//
//  Created by FangLin on 2019/11/18.
//  Copyright © 2019 FangLin. All rights reserved.
//

import Foundation

extension XCMsgLocationController: MAMapViewDelegate {
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        ///修改标注的图片
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: MAAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier)
            
            if annotationView == nil {
                annotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            annotationView!.image = UIImage(named: "poi_checkbox_on")
            annotationView!.centerOffset = CGPoint.init(x: 0, y: -25)
            return annotationView!
        }
        return nil
    }
    
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        if updatingLocation {
            Dprint(userLocation.location)
            ///更新用户当前位置的标注点图片
            let userLocationRep = MAUserLocationRepresentation()
            userLocationRep.image = UIImage.init(named: "pickLocation_selfview")
            mapView.update(userLocationRep)
        }
    }
    
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        if wasUserAction {
            currentLocationCoordinate = mapView.region.center
            searchListView.tableView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
            searchListView.selectedIndexPath = IndexPath.init(row: 0, section: 0)
            AMapLocationHelper.shared().setMapPOIAroundSearchRequest(latitude: currentLocationCoordinate.latitude, longitude: currentLocationCoordinate.longitude)
        }
    }
}

/// POI周边搜索请求回调
extension XCMsgLocationController:AMapReGeocodeSearchDelegate {
    func onPOISearchFinish(request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        searchListView.dataList.removeAll()
        searchListView.dataList = response.pois
        searchListView.tableView.reloadData()
        if searchListView.dataList.count > 0 {
            let model = searchListView.dataList[0]
            let subAddressStr:String = model.name ?? model.address
            let addressStr = model.province + model.city + model.district + model.address
            let title = addressStr + "," + subAddressStr
            titleStr = title
        }
    }
}

///选中地图POI地址的回调
extension XCMsgLocationController:XCLocationSearchListViewDelegate {
    func didSelectLocationFinish(latitude: Double, longitude: Double, title: String) {
        currentLocationCoordinate = CLLocationCoordinate2DMake(latitude, longitude)
        titleStr = title
        mapView?.setCenter(currentLocationCoordinate, animated: true)
    }
}
