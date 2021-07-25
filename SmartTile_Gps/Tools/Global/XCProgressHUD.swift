//
//  XCProgressHUD.swift
//  
//
//  Created by FangLin on 2019/1/15.
//  Copyright © 2019年 FangLin. All rights reserved.
//

import UIKit
import SVProgressHUD

fileprivate enum HUDType: Int {
    case success
    case errorObject
    case errorString
    case info
    case loading
}

class XCProgressHUD: NSObject {
    class func XC_initHUD() {
        SVProgressHUD.setBackgroundColor(UIColor ( red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7 ))
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setFont(UIFont.systemFont(ofSize: 14))
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.none)
    }
    
    //成功
    class func XC_showSuccess(withStatus string: String?) {
        self.XCProgressHUDShow(.success, status: string)
    }
    
    //失败 ，NSError
    class func XC_showError(withObject error: NSError) {
        self.XCProgressHUDShow(.errorObject, status: nil, error: error)
    }
    
    //失败，String
    class func XC_showError(withStatus string: String?) {
        self.XCProgressHUDShow(.errorString, status: string)
    }
    
    //转菊花
    class func XC_showWithStatus(_ string: String?) {
        self.XCProgressHUDShow(.loading, status: string)
    }
    
    //警告
    class func XC_showWarning(withStatus string: String?) {
        self.XCProgressHUDShow(.info, status: string)
    }
    
    //dismiss消失
    class func XC_dismiss() {
        SVProgressHUD.dismiss()
    }
    
    //私有方法
    fileprivate class func XCProgressHUDShow(_ type: HUDType, status: String? = nil, error: NSError? = nil) {
        SVProgressHUD.setDefaultMaskType(.none)
        switch type {
        case .success:
            SVProgressHUD.showSuccess(withStatus: status)
            break
        case .errorObject:
            guard let newError = error else {
                SVProgressHUD.showError(withStatus: "Error:出错拉")
                return
            }
            
            if newError.localizedFailureReason == nil {
                SVProgressHUD.showError(withStatus: "Error:出错拉")
            } else {
                SVProgressHUD.showError(withStatus: error!.localizedFailureReason)
            }
            break
        case .errorString:
            SVProgressHUD.showError(withStatus: status)
            break
        case .info:
            SVProgressHUD.showInfo(withStatus: status)
            break
        case .loading:
            SVProgressHUD.setDefaultMaskType(.clear)
            SVProgressHUD.show(withStatus: status)
            break
        }
    }
    
}
