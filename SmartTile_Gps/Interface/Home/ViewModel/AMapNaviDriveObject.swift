//
//  AMapNaviDriveObject.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/9/8.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit

@objc protocol AMapNaviDriveObjectDelegate : NSObjectProtocol {
    @objc optional func onCalculateRouteSuccess(driveManager: AMapNaviDriveManager, routeId: Int32)
    
}

class AMapNaviDriveObject: NSObject {
    
    weak var mapDelegate: AMapNaviDriveObjectDelegate?
    
    var routeId:Int32 = 0

    private static var _sharedInstance:AMapNaviDriveObject?
    
    class func shared() -> AMapNaviDriveObject{
        guard let instance = _sharedInstance else {
            _sharedInstance = AMapNaviDriveObject()
            return _sharedInstance!
        }
        return instance
    }
    
    
    
    func calculateDriveRouteId(withStart startPoints: [AMapNaviPoint], end endPoints: [AMapNaviPoint], wayPoints: [AMapNaviPoint]?, drivingStrategy strategy: AMapNaviDrivingStrategy, routeId:Int32) {
        self.routeId = routeId
        AMapNaviDriveManager.sharedInstance().calculateDriveRoute(withStart: startPoints, end: endPoints, wayPoints: wayPoints, drivingStrategy: strategy)
    }
}

extension AMapNaviDriveObject: AMapNaviDriveManagerDelegate {
    func driveManager(onCalculateRouteSuccess driveManager: AMapNaviDriveManager) {
        mapDelegate?.onCalculateRouteSuccess?(driveManager: driveManager, routeId: routeId)
    }
}
