//
//  XCAddFriendSearchController.swift
//  XinChat
//
//  Created by FangLin on 2019/10/16.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit
import NIMSDK

class XCAddFriendSearchController: SBaseController {
    
    var nav:UINavigationController?
    
    let tipBgV = UIView.init()
    let tipLabel = UILabel.init()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.edgesForExtendedLayout = .all
    
        self.view.backgroundColor = HEXCOLOR(h: 0xffffff, alpha: 0.6)
//        self.view.addBlurEffectView(frame: self.view.bounds)
        
        tipBgV.backgroundColor = .white
        tipBgV.isHidden = true
        self.view.addSubview(tipBgV)
        tipBgV.snp.makeConstraints { (make) in
            make.top.equalTo(100*IPONE_SCALE)
            make.left.right.equalToSuperview()
            make.height.equalTo(100*IPONE_SCALE)
        }
        
        tipBgV.addSubview(tipLabel)
        tipLabel.font = UIFont.systemFont(ofSize: CGFloat(16*IPONE_SCALE))
        tipLabel.textColor = HEXCOLOR(h: 0x999999, alpha: 1)
        tipLabel.text = "该用户不存在"
        tipLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(15*IPONE_SCALE)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tipBgV.isHidden = true
        guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        if rootVC.isKind(of: UITabBarController.classForCoder()) {
            let tabbarVC = rootVC as! UITabBarController
            tabbarVC.edgesForExtendedLayout = UIRectEdge.bottom
        }
        
    }
}

extension XCAddFriendSearchController: UISearchResultsUpdating,UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        searchController.searchResultsController?.view.isHidden = false
        searchController.searchBar.setShowsCancelButton(true, animated: true)
    }
    
    //MARK: - UISearchBarDelegate
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchStr = searchBar.text else {
            return
        }
        XCXinChatTools.shared.searchUserInfo(searchStr) { (code, userInfo) in
            if code == "200" {
                if userInfo == nil {
                    self.tipBgV.isHidden = false
                }else {
                    self.tipBgV.isHidden = true
                    var userInfoVC:UserInfoController!
                    if XCXinChatTools.shared.isMyFriend(searchStr) {
                        userInfoVC = UserInfoController.init(funcType: .SendMessage)
                    }else {
                        userInfoVC = UserInfoController.init(funcType: .AddBook)
                    }
                    userInfoVC.userId = searchStr
                    self.nav?.pushViewController(userInfoVC, animated: true)
                }
            }else {
                self.tipBgV.isHidden = false
            }
        }
    }
}

