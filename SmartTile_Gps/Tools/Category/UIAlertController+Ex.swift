//
//  UIAlertController+Ex.swift
//  XinChat
//
//  Created by FangLin on 2019/8/6.
//  Copyright © 2019 FangLin. All rights reserved.
//

import Foundation

extension UIAlertController {
    
    /// 初始化警告视图
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 消息内容
    ///   - cancleTitle: 按钮标题
    @objc static func initAlertView(title:String, message:String, cancleTitle:String) -> UIAlertController  {
        let alertCtrl = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: cancleTitle, style: .cancel, handler: nil)
        alertCtrl.addAction(cancelAction)
        return alertCtrl
    }
    
    /// 初始化警告视图
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 消息内容
    ///   - cancleTitle: 按钮标题
    ///   - cancleAction: 按钮行为
    @objc static func initAlertView(title:String, message:String, cancleTitle:String,cancleAction:@escaping ((UIAlertAction) -> Void)) -> UIAlertController  {
        let alertCtrl = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: cancleTitle, style: .cancel, handler: cancleAction)
        alertCtrl.addAction(cancelAction)
        return alertCtrl
    }
    
    /// 初始化警告视图
    ///
    /// - Parameters:
    ///   - message: 消息内容
    ///   - sureTitle: 确定按钮标题
    ///   - sureAction: 确定按钮行为
    @objc static func initAlertView(message:String, sureTitle:String, sureAction:@escaping ((UIAlertAction) -> Void)) -> UIAlertController  {
        let alertCtrl = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
        let sureAction = UIAlertAction.init(title: sureTitle, style: .default, handler: sureAction)
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alertCtrl.addAction(sureAction)
        alertCtrl.addAction(cancelAction)
        return alertCtrl
    }
    
    /// 初始化警告视图
    ///
    /// - Parameters:
    ///   - message: 消息内容
    ///   - sureTitle: 确定按钮标题
    ///   - sureAction: 确定按钮行为
    ///   - cancleTitle: 取消按钮标题
    ///   - cancleAction: 取消按钮行为
    @objc static func initAlertView(message:String, sureTitle:String, sureAction:@escaping ((UIAlertAction) -> Void), cancleTitle:String,cancleAction:@escaping ((UIAlertAction) -> Void)) -> UIAlertController  {
        let alertCtrl = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
        let sureAction = UIAlertAction.init(title: sureTitle, style: .default, handler: sureAction)
        let cancelAction = UIAlertAction.init(title: cancleTitle, style: .cancel, handler: cancleAction)
        alertCtrl.addAction(sureAction)
        alertCtrl.addAction(cancelAction)
        return alertCtrl
    }
    
    /// 初始化警告视图
    ///
    /// - Parameters:
    ///   - title:标题
    ///   - message: 消息内容
    ///   - sureTitle: 确定按钮标题
    ///   - sureAction: 确定按钮行为
    @objc static func initAlertView(title:String, message:String, sureTitle:String, sureAction:@escaping ((UIAlertAction) -> Void)) -> UIAlertController  {
        let alertCtrl = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let sureAction = UIAlertAction.init(title: sureTitle, style: .default, handler: sureAction)
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alertCtrl.addAction(sureAction)
        alertCtrl.addAction(cancelAction)
        return alertCtrl
    }
    
    /// 初始化警告视图
    ///
    /// - Parameters:
    ///   - title:标题
    ///   - message: 消息内容
    ///   - sureTitle: 确定按钮标题
    ///   - sureAction: 确定按钮行为
    ///   - cancleTitle: 取消按钮标题
    ///   - cancleAction: 取消按钮行为
    @objc static func initAlertView(title:String, message:String, sureTitle:String, sureAction:@escaping ((UIAlertAction) -> Void), cancleTitle:String,cancleAction:@escaping ((UIAlertAction) -> Void)) -> UIAlertController  {
        let alertCtrl = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let sureAction = UIAlertAction.init(title: sureTitle, style: .default, handler: sureAction)
        let cancelAction = UIAlertAction.init(title: cancleTitle, style: .cancel, handler: cancleAction)
        alertCtrl.addAction(sureAction)
        alertCtrl.addAction(cancelAction)
        return alertCtrl
    }
    
    /// 初始化警告视图(底部)
    ///
    /// - Parameters:
    ///   - sureTitle: 确定按钮标题
    ///   - sureAction: 确定按钮行为
    @objc static func initSheetView(sureTitle:String, sureAction:@escaping ((UIAlertAction) -> Void)) -> UIAlertController {
        let alertCtrl = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let sureAction = UIAlertAction.init(title: sureTitle, style: .default, handler: sureAction)
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alertCtrl.addAction(sureAction)
        alertCtrl.addAction(cancelAction)
        return alertCtrl
    }
    
    /// 初始化警告视图(底部)
    ///
    /// - Parameters:
    ///   - sureTitle1: 按钮一标题
    ///   - sureAction1: 按钮一行为
    ///   - sureTitle2: 按钮二标题
    ///   - sureAction2: 按钮二行为
    @objc static func initSheetView(title1:String, action1:@escaping ((UIAlertAction) -> Void), title2:String, action2:@escaping ((UIAlertAction) -> Void)) -> UIAlertController {
        let alertCtrl = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let sureAction1 = UIAlertAction.init(title: title1, style: .default, handler: action1)
        let sureAction2 = UIAlertAction.init(title: title2, style: .default, handler: action2)
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alertCtrl.addAction(sureAction1)
        alertCtrl.addAction(sureAction2)
        alertCtrl.addAction(cancelAction)
        return alertCtrl
    }
}
