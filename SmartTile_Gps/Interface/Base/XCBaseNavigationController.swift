//
//  XCBaseNavigationController.swift
//  XinChat
//
//  Created by FangLin on 2019/10/16.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit

//导航栏（废弃）
class XCBaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count == 1 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    
    func setNavStyles() {
        // 设置导航栏样式
//        navigationBar.barStyle = .default
        navigationBar.barTintColor = kNavBarBgColor
        
        // 标题样式
        let bar = UINavigationBar.appearance()
//        bar.titleTextAttributes = [
//            NSAttributedString.Key.foregroundColor : HEXCOLOR(h: 0x333333, alpha: 1),
//            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: CGFloat(18*IPONE_SCALE))
//        ]
        
//        // 设置返回按钮的样式
//        navigationBar.tintColor = HEXCOLOR(h: 0x333333, alpha: 1)     // 设置返回标识器的颜色
//        let barItem = UIBarButtonItem.appearance()
//        barItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .normal)  // 返回按钮文字样式
        //替换原来的返回图片
//        bar.tintColor = HEXCOLOR(h: 0x333333, alpha: 1)
//        bar.backIndicatorImage = UIImage.init(named: "Icon_Back")
//        bar.backIndicatorTransitionMaskImage = UIImage.init(named: "Icon_Back")
        //去掉导航栏下划线
        bar.setBackgroundImage(UIImage.init(), for: .default)
        bar.shadowImage = UIImage.init()
    }

    
}
