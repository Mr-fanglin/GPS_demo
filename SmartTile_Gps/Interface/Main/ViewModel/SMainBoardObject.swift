//
//  SMainBoardObject.swift
//  Sprayer
//
//  Created by fanglin on 2020/4/17.
//  Copyright © 2020 FangLin. All rights reserved.
//

import UIKit

class SMainBoardObject: NSObject {
    private static var _sharedInstance: SMainBoardObject?
    private override init() {
         
    }
    
    class func shared() -> SMainBoardObject {
        guard let instance = _sharedInstance else {
            _sharedInstance = SMainBoardObject()
            return _sharedInstance!
        }
        return instance
    }
    
    @objc class func destroy() {
        _sharedInstance = nil
    }
    
    //用户账号Id
    var idAccount:Int32 = 0
    
    //当前设备Id
    var currentChildId:Int32 = 0
    
    //当前位置
    var currentLocation = CLLocationCoordinate2D()
    
    //mqtt连接成功的状态
    var isMqttConnect = false
    
}
