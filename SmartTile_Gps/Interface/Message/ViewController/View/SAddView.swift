//
//  SAddView.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/8/27.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit

class SAddView: AniCommonShowCloseView,UITableViewDelegate,UITableViewDataSource {
    
    // MARK: 功能
    lazy var funcArr: [XCContactCellModel] = {
        return XCUIDataHelper.addFriendFuncs()
    }()
    
    lazy var tableView:UITableView = {
        let tbView = UITableView.init(frame: .zero, style: .plain)
        tbView.backgroundColor = HEXCOLOR(h: 0x666666, alpha: 1)
        tbView.delegate = self
        tbView.dataSource = self
        return tbView
    }()

    //MARK: - SYSTEM
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
        self.backgroundColor = HEXCOLOR(h: 0x666666, alpha: 1)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(5*IPONE_SCALE)
            make.bottom.equalTo(-5*IPONE_SCALE)
        }
        tableView.register(SAddViewCell.classForCoder(), forCellReuseIdentifier: "SAddViewCell")
    }
    
    //MARK: - UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return funcArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SAddViewCell") as! SAddViewCell
        let model = funcArr[indexPath.row]
        cell.titleL.text = model.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(40*IPONE_SCALE)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.animationClose()
        if indexPath.row == 0 {
            let addFriendVC = XCAddFriendController()
            UIViewController.getCurrentViewCtrl().navigationController?.pushViewController(addFriendVC, animated: true)
        }else if indexPath.row == 1 {
            var users:[String] = []
            let config = NIMContactFriendSelectConfig()
            let currentUserId = XCXinChatTools.shared.getCurrentUserId()
            users.append(currentUserId)
            config.filterIds = users
            config.needMutiSelected = true
            
            let contactVC = NIMContactSelectViewController.init(config: config)
            UIViewController.getCurrentViewCtrl().navigationController?.pushViewController(contactVC!, animated: true)
        }
    }
}
