//
//  HomeBoardObject.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/8/25.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit

class HomeBoardObject: NSObject {

    private static var _sharedInstance:HomeBoardObject?
    private override init() {
        
    }
    
    class func shared() -> HomeBoardObject{
        guard let instance = _sharedInstance else {
            _sharedInstance = HomeBoardObject()
            
            return _sharedInstance!
        }
        return instance
    }
    
    
    class func destory() {
        _sharedInstance = nil
    }
    
    lazy var childStatusView:ChildStatusView = {
        let queue = ChildStatusView.init(frame: CGRect.init(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: 0))
        return queue
    }()
}
