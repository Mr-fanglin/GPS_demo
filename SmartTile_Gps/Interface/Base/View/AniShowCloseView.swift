//
//  AniShowCloseView.swift
//  Sheng
//
//  Created by DS on 2017/12/29.
//  Copyright © 2017年 First Cloud. All rights reserved.
//

import UIKit

/// 点击透明背景动态收起视图(需要创建的时候指定size,不需要添加在父视图上)
class AniShowCloseView: UIView {
    
    /// 隐藏/显示的透明背景图
    lazy var colorlessBackground:UIView = {
        let view = UIView.init()
        view.frame = UIScreen.main.bounds
        view.backgroundColor = .clear
        //透明背景手势
        let tapG = UITapGestureRecognizer.init(target: self, action: #selector(animationClose))
        view.addGestureRecognizer(tapG)
        return view
    }()
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    /// 动态收起
    @objc func animationClose() {
        UIView.animate(withDuration: 0.2, animations: {
            self.isHidden = true
            self.frame = CGRect(x:0, y:SCREEN_HEIGHT, width:self.frame.size.width, height:self.frame.size.height)
            self.center.x = SCREEN_WIDTH/2
        }) { (finish) in
//            self.colorlessBackground.removeFromSuperview()
            self.removeFromSuperview()
        }
    }
    
    /// 弹出
    ///
    /// - Parameter isCenter: 是否是在界面中心
    func animationshow(isCenter:Bool,duration:TimeInterval,isTabbar:Bool=false) {
//        UIViewController.getCurrentViewCtrl().view.addSubview(colorlessBackground)
        UIViewController.getCurrentViewCtrl().view.addSubview(self)
        self.isHidden = false
        self.frame = CGRect(x:0, y:SCREEN_HEIGHT, width:self.frame.size.width, height:self.frame.size.height)
        self.center.x = SCREEN_WIDTH/2
        UIView.animate(withDuration: duration) {
            if isCenter{
                self.center = UIViewController.getCurrentViewCtrl().view.center
            }else{
                if isTabbar {
                    self.frame.origin.y = SCREEN_HEIGHT-self.frame.size.height-TabbarHeight
                }else {
                    self.frame.origin.y = SCREEN_HEIGHT-self.frame.size.height
                }
                
            }
        }
    }
}
