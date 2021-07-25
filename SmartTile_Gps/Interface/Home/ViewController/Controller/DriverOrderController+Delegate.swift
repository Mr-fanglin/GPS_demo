//
//  DriverOrderController+Delegate.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/9/22.
//  Copyright © 2020 fanglin. All rights reserved.
//

import Foundation

extension DriverOrderController:MAMapViewDelegate {
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: MAPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as! MAPinAnnotationView?
            
            if annotationView == nil {
                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            
            if let mapAnnotation = annotationView?.annotation {
                if mapAnnotation.coordinate.latitude == startLocationCoordinate.latitude && mapAnnotation.coordinate.longitude == startLocationCoordinate.longitude {
                    annotationView?.image = UIImage.init(named: "home_journey_ic_start")
                }else if mapAnnotation.coordinate.latitude == endLocationCoordinate.latitude && mapAnnotation.coordinate.longitude == endLocationCoordinate.longitude {
                    annotationView?.image = UIImage.init(named: "home_journey_ic_end")
                }
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
            
        }
    }
        
    func mapView(_ mapView: MAMapView!, didAddAnnotationViews views: [Any]!) {
        guard let piView:MAPinAnnotationView = views[0] as? MAPinAnnotationView else {
            return
        }
        mapView.selectAnnotation(piView.annotation, animated: true)
    }
    
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        if overlay.isKind(of: MAPolyline.self) {
            let renderer: MAPolylineRenderer = MAPolylineRenderer(overlay: overlay)
            renderer.lineWidth = 5
            renderer.strokeColor = UIColor.blue
            return renderer
        }
        return nil
    }
}

extension DriverOrderController:MQTTHelperDelegate {
    func mqttOrderUpdate(message: OrderModel) {
        //加载动画
        self.view.makeToastActivity(.center)
        HomeRequestObject.shared.requestOrderProgress(orderId: self.model.id) { [weak self](dataList) in
            if let weakself = self {
                weakself.view.hideToastActivity()
                weakself.orderStatusView.progressList = dataList
            }
        }
    }
}


extension DriverOrderController:AMapNaviDriveObjectDelegate {
    func onCalculateRouteSuccess(driveManager: AMapNaviDriveManager, routeId: Int32) {
        var lineCoordinates:[CLLocationCoordinate2D] = []
        guard let coordinates = driveManager.naviRoute?.routeCoordinates else {
            return
        }
        for point in coordinates {
            let locationCoordinate = CLLocationCoordinate2D(latitude: Double(point.latitude), longitude: Double(point.longitude))
            lineCoordinates.append(locationCoordinate)
        }
        Dprint("driveManager:\(driveManager.naviRouteID)")
        let polyline: MAPolyline = MAPolyline(coordinates: &lineCoordinates, count: UInt(lineCoordinates.count))
        self.mapView.add(polyline)
    }
}

/// 逆地理编码请求回调
extension DriverOrderController:AMapReGeocodeSearchDelegate {
    func amapLocationManagerdidUpdatelocation(location: CLLocation!) {
        driveCurrentLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    func onReGeocodeSearchFinish(request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        if Double(request.location.latitude) == model.fromLatitude {
            if response.regeocode.roads.count > 0 {
                let roadName = response.regeocode.roads[0].name
                if response.regeocode.pois.count > 0 {
                    let poisName = response.regeocode.pois[0].name
                    self.driveStatusView.startLocation.text = roadName! + "-" + poisName!
                }else {
                    self.driveStatusView.startLocation.text = response.regeocode.formattedAddress
                }
            }else {
                self.driveStatusView.startLocation.text = response.regeocode.formattedAddress
            }
        }else if Double(request.location.latitude) == model.toLatitude {
            if response.regeocode.roads.count > 0 {
                let roadName = response.regeocode.roads[0].name
                if response.regeocode.pois.count > 0 {
                    let poisName = response.regeocode.pois[0].name
                    self.driveStatusView.endLocation.text = roadName! + "-" + poisName!
                }else {
                    self.driveStatusView.endLocation.text = response.regeocode.formattedAddress
                }
            }else {
                self.driveStatusView.endLocation.text = response.regeocode.formattedAddress
            }
        }
    }
}


extension DriverOrderController {
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

