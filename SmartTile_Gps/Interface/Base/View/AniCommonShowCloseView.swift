//
//  AniCommonShowCloseView.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/8/28.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit

class AniCommonShowCloseView: UIView {

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
            self.frame = CGRect(x:self.frame.origin.x, y:self.frame.origin.y, width:self.frame.size.width, height:self.frame.size.height)
        }) { (finish) in
            self.colorlessBackground.removeFromSuperview()
            self.removeFromSuperview()
        }
    }
    
    /// 弹出
    ///
    /// - Parameter isCenter: 是否是在界面中心
    func animationshow() {
        UIViewController.getCurrentViewCtrl().view.addSubview(colorlessBackground)
        UIViewController.getCurrentViewCtrl().view.addSubview(self)
        self.isHidden = false
    }

}
