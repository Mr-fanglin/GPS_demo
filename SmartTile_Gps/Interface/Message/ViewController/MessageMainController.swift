//
//  MessageMainController.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/8/26.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit

class MessageMainController: UIViewController,UIScrollViewDelegate {
    
    var addView = SAddView.init(frame: CGRect.init(x: SCREEN_WIDTH-CGFloat(165*IPONE_SCALE), y: CGFloat(60*IPONE_SCALE)+STATUSBAR_HEIGHT, width: CGFloat(120*IPONE_SCALE), height: CGFloat(140*IPONE_SCALE)))
    
    var navView = SNavBarView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: CGFloat(65*IPONE_SCALE)))
    var bgScrollView:UIScrollView = UIScrollView.init()
    
    var messageListVC = XinChatController.init()
    var contactVC = XCContactController.init()
    var groupVC = GroupController.init()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.setUI()
    }
    
    //MARK:  界面
    func setUI(){
        self.setScrollUI()
        self.setNavUI()
    }

    func setNavUI() {
        navView.clickTitleBlock = {
            [weak self](index) in
            if let weakSelf = self {
                weakSelf.bgScrollView.setContentOffset(CGPoint.init(x: SCREEN_WIDTH * CGFloat(index), y: 0), animated: true)
            }
        }
        
        navView.addBtnActionBlock = {[weak self]() in
            if let weakself = self {
                weakself.addView.animationshow()
            }
        }
        
        navView.setUpShadowView(shadowColor: HEXCOLOR(h: 0x000000, alpha: 0.2), size: CGSize.init(width: 0, height: 2), opacity: 0.8, radius: 3)
        self.view.addSubview(navView)
        navView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(CGFloat(10*IPONE_SCALE)+STATUSBAR_HEIGHT)
            make.height.equalTo(65*IPONE_SCALE)
        }
        
    }
    
    func setScrollUI(){
        bgScrollView.frame = CGRect.init(x: 0, y:CGFloat(75*IPONE_SCALE)+STATUSBAR_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-CGFloat(60*IPONE_SCALE)-STATUSBAR_HEIGHT-TabbarHeight)
        bgScrollView.contentOffset = CGPoint.init(x: 0, y: 0)
        bgScrollView.contentSize = CGSize(width:SCREEN_WIDTH*3, height:SCREEN_HEIGHT-CGFloat(75*IPONE_SCALE)-STATUSBAR_HEIGHT-TabbarHeight)
        bgScrollView.isPagingEnabled = true
        bgScrollView.showsVerticalScrollIndicator = false
        bgScrollView.showsHorizontalScrollIndicator = false
        bgScrollView.delegate = self
        bgScrollView.backgroundColor = .white
        bgScrollView.bounces = false
        self.view.addSubview(bgScrollView)
        self.notDistrubSlipBack(with: bgScrollView)
        
        self.addChild(messageListVC)
        messageListVC.view.frame = CGRect.init(x:0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-CGFloat(75*IPONE_SCALE)-STATUSBAR_HEIGHT-TabbarHeight)
        bgScrollView.addSubview(messageListVC.view)

        self.addChild(contactVC)
        contactVC.view.frame = CGRect.init(x: SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-CGFloat(75*IPONE_SCALE)-STATUSBAR_HEIGHT-TabbarHeight)
        bgScrollView.addSubview(contactVC.view)
        
        self.addChild(groupVC)
        groupVC.view.frame = CGRect.init(x: SCREEN_WIDTH*2, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-CGFloat(75*IPONE_SCALE)-STATUSBAR_HEIGHT-TabbarHeight)
        bgScrollView.addSubview(groupVC.view)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x/SCREEN_WIDTH
        navView.curIndex = Int(index)
        
    }
}
