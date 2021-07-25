//
//  SMainPageController.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/8/17.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit

class SMainPageController: UITabBarController,UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBar.isTranslucent = true
        self.selectedIndex = 0
        
        // 设置一个自定义 View,大小等于 tabBar 的大小
        let bgView = UIView()
        bgView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: TabbarHeight)
        bgView.backgroundColor = HEXCOLOR(h: 0xF7F7F7, alpha: 0.8)
        // 将自定义 View 添加到 tabBar 上
        self.tabBar.insertSubview(bgView, at: 0)
        //隐藏导航
        if let navigationController = navigationController {
            navigationController.setNavigationBarHidden(true, animated: false)
            navigationController.interactivePopGestureRecognizer?.delegate = self
        }
        
        self.setUpTabbar()
        self.setSubViewController()
        
        /*------ 地图 --------*/
        AMapLocationHelper.shared().initAMapLocation()
        
        MQTTHelper.shared().initMqtt()
    }
    
    func setUpTabbar() {
        self.tabBar.layer.shadowColor = HEXCOLOR(h: 0xe2e2e2, alpha: 1).cgColor
        self.tabBar.layer.shadowOffset = CGSize.init(width: 2, height: 5)
        self.tabBar.layer.shadowOpacity = 1
        self.tabBar.layer.shadowRadius = 5
        self.tabBar.shadowImage = UIImage()
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.backgroundColor = .white
        
        UITabBarItem.appearance().setTitleTextAttributes(NSDictionary.init(object: HEXCOLOR(h: 0x999999, alpha: 1), forKey: NSAttributedString.Key.foregroundColor as NSCopying) as? [NSAttributedString.Key : Any], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(NSDictionary.init(object: Main_Color, forKey: NSAttributedString.Key.foregroundColor as NSCopying) as? [NSAttributedString.Key : Any], for: .selected)
        
        self.tabBar.tintColor = HEXCOLOR(h: 0x333333, alpha: 1)
    }
    

    func setSubViewController() {
        setUpChildViewController(HomeController(), title: "Home", normalImage: "home_bar_normal", selectedImage: "home_bar_sel")
        setUpChildViewController(MineController(), title: "Mine", normalImage: "home_bar_mine_normal", selectedImage: "home_bar_mine_sel")
    }

    func setUpChildViewController(_ vc:UIViewController,title:String,normalImage:String,selectedImage:String){
        vc.tabBarItem.title = title
        vc.tabBarItem.image = UIImage.init(named: normalImage)?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.selectedImage = UIImage.init(named: selectedImage)?.withRenderingMode(.alwaysOriginal)
        let baseNav = UINavigationController.init(rootViewController: vc)
        baseNav.navigationBar.isHidden = true
        self.addChild(baseNav)
    }
}

