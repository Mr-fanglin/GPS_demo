//
//  SBaseController.swift
//  Sheng
//
//  Created by DS on 2017/7/11.
//  Copyright © 2017年 First Cloud. All rights reserved.
//

/**
 * @brief: 视图控制器基类
 */

import UIKit

class SBaseController: UIViewController {

    
    /// 导航标题
    lazy var navTitleL:UILabel = {
        let nTitle = UILabel.init()
        nTitle.textAlignment = .center
        nTitle.font = UIFont.boldSystemFont(ofSize: CGFloat(17*IPONE_SCALE))
        nTitle.textColor = HEXCOLOR(h: 0x3b3b3b, alpha: 1)
        return nTitle
    }()
    
    /// 导航是否是透明色
    var isNavBarClear:Bool = false{
        didSet{
            if isNavBarClear == true{
                navBarV.backgroundColor = .clear
                navTitleL.textColor = .white
                if rightBtn.title(for: .normal) != nil{
                    rightBtn.setTitleColor(.white, for: .normal)
                }
            }else{
                navBarV.backgroundColor = .white
                navTitleL.textColor = .black
                if rightBtn.title(for: .normal) != nil{
                    rightBtn.setTitleColor(HEXCOLOR(h: 0x303030, alpha: 1), for: .normal)
                }
            }
        }
    }
    
    //设置导航栏透明度
    var navbarAlpha:CGFloat = 0 {
        didSet{
            navBarV.alpha = navbarAlpha
        }
    }
    
    // MARK: - PRIVAE
    lazy var navBarV:UIView = {
        let barV = UIView.init()
        barV.backgroundColor = .white
        return barV
    }()  // 导航背景
    
    lazy var baseBackBtn:UIButton = {
        let bBtn = UIButton.init(type: .custom)
        return bBtn
    }()
    
    lazy var rightBtn:UIButton = {
        let rBtn = UIButton.init(type: .custom)
        return rBtn
    }()
    
    // MARK: - system method
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    ///设置tabbar角标
    func settingBadgeValue(tabbarItem:Int,count:Int) {
        let item = self.tabBarController?.tabBar.items?[tabbarItem]
        if count > 0 {
            item?.badgeValue = "\(count)"
        } else {
            item?.badgeValue = nil
        }
    }
    
    // MARK: - public method
    //从 storyboard 中获取视图控制器
    static func loadFromStoryboard(storyboard:String) -> UIViewController {
        if let identifier = NSStringFromClass(self.classForCoder()) .components(separatedBy: ".") .last{
            return UIStoryboard(name: storyboard,bundle: Bundle.main).instantiateViewController(withIdentifier: identifier)
        }else{
            print("视图控制器 loadFromStoryboard 失败")
            return UIViewController.init()
        }
    }
    
    
    /// 返回方法(可重写)
    @objc public func navBackAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    /// 重设导航
    ///
    /// - Parameters:
    ///   - isClear: 是否透明 是_文字为白色
    ///   - leftImage: 左边图片
    ///   - rightImage: 右边图片
    func resetNavbar(isClear:Bool?, leftImage:String?, rightImage:String?) {
        if let isClear = isClear{
            self.isNavBarClear = isClear
        }
        if let leftStr = leftImage{
            baseBackBtn.setImage(UIImage.init(named: leftStr), for: .normal)
        }
        if let rightString = rightImage {
            rightBtn.setImage(UIImage.init(named: rightString), for: .normal)
        }
    }
    /// 创建导航(返回按钮为图片,右侧按钮为图片或无)
    ///
    /// - Parameters:
    ///   - navTitle: 标题
    ///   - leftImage: 返回按钮图片
    ///   - rightImage: 右侧按钮图片
    ///   - ringhtAction: 右侧按钮方法
    func createNavbar(navTitle:String, leftImage:String?, rightImage:String?, ringhtAction:Selector?) {
        self.createNavbar(navTitle: navTitle, leftIsImage: true, leftStr: leftImage, rightIsImage: true, rightStr: rightImage, leftAction: nil, ringhtAction: ringhtAction)
    }
    
    /// 创建导航(返回按钮为图片,右侧按钮为文字或无)
    ///
    /// - Parameters:
    ///   - navTitle: 标题
    ///   - leftImage: 返回按钮图片
    ///   - rightImage: 右侧按钮标题
    ///   - ringhtAction: 右侧按钮方法
    func createNavbar(navTitle:String, leftImage:String?, rightStr:String?, ringhtAction:Selector?) {
        self.createNavbar(navTitle: navTitle, leftIsImage: true, leftStr: leftImage, rightIsImage: false, rightStr: rightStr, leftAction: nil, ringhtAction: ringhtAction)
    }
    
    
    /// 创建导航(左侧按钮为文字,右侧按钮为文字或无)
    ///
    /// - Parameters:
    ///   - navTitle: 标题
    ///   - leftTitle: 左侧按钮标题
    ///   - rightTitle: 右侧按钮标题
    ///   - leftAction: 左侧按钮方法
    ///   - ringhtAction: 右侧按钮方法
    func createNavbar(navTitle:String, leftTitle:String?, rightTitle:String?, leftAction:Selector?, ringhtAction:Selector?) {
        self.createNavbar(navTitle: navTitle, leftIsImage: false, leftStr: leftTitle, rightIsImage: false, rightStr: rightTitle, leftAction: leftAction, ringhtAction: ringhtAction)
    }
    
    /// 创建导航(左侧按钮为文字,右侧按钮为图片或无)
    ///
    /// - Parameters:
    ///   - navTitle: 标题
    ///   - leftTitle: 左侧按钮标题
    ///   - rightImage: 右侧按钮标题
    ///   - leftAction: 左侧按钮方法
    ///   - ringhtAction: 右侧按钮方法
    func createNavbar(navTitle:String, leftTitle:String?, rightImage:String?, leftAction:Selector?, ringhtAction:Selector?) {
        self.createNavbar(navTitle: navTitle, leftIsImage: false, leftStr: leftTitle, rightIsImage: true, rightStr: rightImage, leftAction: leftAction, ringhtAction: ringhtAction)
    }
    
    /// 创建导航(左侧按钮为图片,右侧按钮为图片或无)
    ///
    /// - Parameters:
    ///   - navTitle: 标题
    ///   - leftTitle: 左侧按钮标题
    ///   - rightImage: 右侧按钮标题
    ///   - leftAction: 左侧按钮方法
    ///   - ringhtAction: 右侧按钮方法
    func createNavbar(navTitle:String, leftImage:String?, rightImage:String?, leftAction:Selector?, ringhtAction:Selector?) {
        self.createNavbar(navTitle: navTitle, leftIsImage: true, leftStr: leftImage, rightIsImage: true, rightStr: rightImage, leftAction: leftAction, ringhtAction: ringhtAction)
    }
    
    
    // MARK: - PRIVATE
    private func createNavbar(navTitle:String, leftIsImage:Bool, leftStr:String?, rightIsImage:Bool, rightStr:String?, leftAction:Selector?, ringhtAction:Selector?) {
        //背景
        self.view.addSubview(navBarV)
        navBarV.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(STATUSBAR_HEIGHT+NavbarHeight)
        }
        //返回按钮
        if leftIsImage {
            if let leftStr = leftStr{
                baseBackBtn.setImage(UIImage.init(named: leftStr), for: .normal)
            }else{
                baseBackBtn.setImage(UIImage.init(named: "Icon_Back"), for: .normal)
            }
        }else{
            if let leftStr = leftStr {
                baseBackBtn.setTitle(leftStr, for: .normal)
                baseBackBtn.setTitleColor(HEXCOLOR(h: 0x303030, alpha: 1), for: .normal)
                baseBackBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            }
        }
        if let leftAction = leftAction {
            baseBackBtn.addTarget(self, action: leftAction, for: .touchUpInside)
        }else{
            baseBackBtn.addTarget(self, action: #selector(navBackAction), for: .touchUpInside)
        }
        navBarV.addSubview(baseBackBtn)
        baseBackBtn.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.height.equalTo(NavbarHeight)
            make.width.equalTo(60)
        }
        //右侧按钮
        if rightIsImage{
            if let rightString = rightStr {
                rightBtn.setImage(UIImage.init(named: rightString), for: .normal)
            }
        }else{
            if let rightString = rightStr {
                rightBtn.setTitle(rightString, for: .normal)
                rightBtn.setTitleColor(HEXCOLOR(h: 0x303030, alpha: 1), for: .normal)
                rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            }
        }
        if let ringhtAction = ringhtAction {
            rightBtn.addTarget(self, action: ringhtAction, for: .touchUpInside)
        }
        navBarV.addSubview(rightBtn)
        rightBtn.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.height.equalTo(NavbarHeight)
            make.width.equalTo(rightIsImage ? NavbarHeight:90)
        }
        //标题
        navTitleL.text = navTitle
        navBarV.addSubview(navTitleL)
        navTitleL.snp.makeConstraints { (make) in
            make.left.equalTo(baseBackBtn.snp.right).offset(((rightIsImage ? 0:(90-NavbarHeight))+10))
            make.right.equalTo(rightBtn.snp.left).offset(-10)
            make.bottom.equalToSuperview()
            make.height.equalTo(NavbarHeight)
        }
    }

}
