//
//  UIViewController+Ex.swift
//  XinChat
//
//  Created by FangLin on 2019/8/6.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit
import Toast_Swift

enum BarBtnItemDirection: Int {
    case left
    case right
}

extension UIViewController {
    
    /// 使嵌入的横向滚动视图不影响控制器的拖返功能
    ///
    /// - Parameter scrollV: 嵌入的横向滚动视图,它也可能是UICollectionView或UITableView
    func notDistrubSlipBack(with scrollV:UIScrollView) {
        if let gestureArr = self.navigationController?.view.gestureRecognizers{
            for gesture in gestureArr {
                if (gesture as AnyObject).isKind(of:UIScreenEdgePanGestureRecognizer.self){
                    scrollV.panGestureRecognizer.require(toFail: gesture)
                }
            }
        }
    }
    
    /// 获取当前视图控制器
    ///
    /// - Returns: 当前视图控制器
    @objc class func getCurrentViewCtrl()->UIViewController{
        var window = UIApplication.shared.keyWindow
        if window?.windowLevel != UIWindow.Level.normal {
            let windows = UIApplication.shared.windows
            for subWin in windows {
                if subWin.windowLevel == UIWindow.Level.normal {
                    window = subWin
                    break
                }
            }
        }
        if let frontView = window?.subviews.first{
            let nextResponder = frontView.next
            if nextResponder?.classForCoder == UIViewController.classForCoder(){
                return nextResponder as! UIViewController
            }else if nextResponder is UINavigationController {
                return (nextResponder as! UINavigationController).visibleViewController!
            }else if nextResponder is UITabBarController {
                let tabbarCtrl = nextResponder as! UITabBarController
                var tabbarSelCtrl = tabbarCtrl.selectedViewController
                if tabbarSelCtrl == nil{
                    tabbarSelCtrl = tabbarCtrl.viewControllers?.first
                }
                return tabbarSelCtrl!
            }
        }
        if window?.rootViewController is UINavigationController {
            return (window?.rootViewController as! UINavigationController).visibleViewController!
        }else if window?.rootViewController is UITabBarController {
            let tabbarCtrl = window?.rootViewController as! UITabBarController
            var tabbarSelCtrl = tabbarCtrl.selectedViewController
            if tabbarSelCtrl == nil{
                tabbarSelCtrl = tabbarCtrl.viewControllers?.first
            }
            if tabbarSelCtrl is UINavigationController {
                if let navRootCtrl = (tabbarSelCtrl as! UINavigationController).visibleViewController{
                    return navRootCtrl
                }
                return tabbarSelCtrl!
            }else{
                return tabbarSelCtrl!
            }
        }else{
            return (window?.rootViewController)!
        }
    }
    
    /// 简单的toast
    ///
    /// - Parameter message: 提示内容
    @objc class func bottomToast(message:String) {
        let curVC = UIViewController.getCurrentViewCtrl()
        curVC.view.makeToast(message, duration: 0.25, position: .bottom)
    }
}



