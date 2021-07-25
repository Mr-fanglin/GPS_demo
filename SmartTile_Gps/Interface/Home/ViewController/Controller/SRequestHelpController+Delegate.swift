//
//  SRequestHelpController+Delegate.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/9/1.
//  Copyright © 2020 fanglin. All rights reserved.
//

import Foundation

extension SRequestHelpController:MAMapViewDelegate {
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: MAPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as! MAPinAnnotationView?
            
            if annotationView == nil {
                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            if annotationView!.annotation.coordinate.latitude == startLocationCoordinate.latitude && annotationView!.annotation.coordinate.longitude == startLocationCoordinate.longitude {
                annotationView?.image = UIImage.init(named: "home_journey_ic_start")
            }else if annotationView!.annotation.coordinate.latitude == endLocationCoordinate.latitude && annotationView!.annotation.coordinate.longitude == endLocationCoordinate.longitude {
                annotationView?.image = UIImage.init(named: "home_journey_ic_end")
            }
            annotationView!.canShowCallout = true
            annotationView!.animatesDrop = false
            annotationView!.isDraggable = true
            return annotationView!
        }
        return nil
    }
    
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        if wasUserAction {
            if self.isChangeStart {
                childLocationCoordinate = mapView.region.center
                AMapLocationHelper.shared().setMapReGeocodeSearchRequest(latitude: childLocationCoordinate.latitude, longitude: childLocationCoordinate.longitude)
            }
        }
    }
        
    func mapView(_ mapView: MAMapView!, didAddAnnotationViews views: [Any]!) {
        guard let piView:MAPinAnnotationView = views[0] as? MAPinAnnotationView else {
            return
        }
        mapView.selectAnnotation(piView.annotation, animated: true)
    }
}

/// 逆地理编码请求回调
extension SRequestHelpController:AMapReGeocodeSearchDelegate {
    
    func onReGeocodeSearchFinish(request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        if response.regeocode.roads.count > 0 {
            let roadName = response.regeocode.roads[0].name
            if response.regeocode.pois.count > 0 {
                let poisName = response.regeocode.pois[0].name
                self.addressView.startAddressStr = roadName! + "-" + poisName!
            }else {
                self.addressView.startAddressStr = response.regeocode.formattedAddress
            }
        }else {
            self.addressView.startAddressStr = response.regeocode.formattedAddress
        }
        self.view.hideToastActivity()
    }
}

///选中地图POI地址的回调
extension SRequestHelpController:SSearchLocationControllerDelegate {
    func didSelectLocationFinish(model: AMapPOI) {
        self.isChangeStart = false
        self.addressView.stopAddressStr = model.address + model.name
        self.addressView.snp.updateConstraints { (make) in
            make.height.equalTo(175*IPONE_SCALE)
        }
        guard let locationInfo = model.location else {
            return
        }
        self.endLocationCoordinate = CLLocationCoordinate2DMake(Double(locationInfo.latitude), Double(locationInfo.longitude))
        
        mapView?.removeAnnotation(childAnnotation)
        self.setStartPoint()
        self.setEndPoint()
        self.showsAnnotations([self.startAnnotation,self.endAnnotation], edgePadding: UIEdgeInsets.init(top: 0, left: 0, bottom: CGFloat(300*IPONE_SCALE), right: 0), andMapView: mapView)
    }
}

extension SRequestHelpController {
    /// 根据传入的annotation来展现：保持中心点不变的情况下，展示所有传入annotation
    ///
    /// - Parameters:
    ///   - annotations: annotation
    ///   - insets: 填充框，用于让annotation不会靠在地图边缘显示
    ///   - mapView: 地图view
    func showsAnnotations(_ annotations:Array<MAPointAnnotation>, edgePadding insets:UIEdgeInsets, andMapView mapView:MAMapView!) {
        var rect:MAMapRect = MAMapRectZero

        for annotation:MAPointAnnotation in annotations {
            let diagonalPoint:CLLocationCoordinate2D = CLLocationCoordinate2DMake(mapView.centerCoordinate.latitude - (annotation.coordinate.latitude - mapView.centerCoordinate.latitude),mapView.centerCoordinate.longitude - (annotation.coordinate.longitude - mapView.centerCoordinate.longitude))

            let annotationMapPoint: MAMapPoint = MAMapPointForCoordinate(annotation.coordinate)
            let diagonalPointMapPoint: MAMapPoint = MAMapPointForCoordinate(diagonalPoint)

            let annotationRect:MAMapRect = MAMapRectMake(min(annotationMapPoint.x, diagonalPointMapPoint.x), min(annotationMapPoint.y, diagonalPointMapPoint.y), abs(annotationMapPoint.x - diagonalPointMapPoint.x), abs(annotationMapPoint.y - diagonalPointMapPoint.y));

            rect = MAMapRectUnion(rect, annotationRect)
        }

        mapView.setVisibleMapRect(rect, edgePadding: insets, animated: true)
    }
}
