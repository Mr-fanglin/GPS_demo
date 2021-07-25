//
//  XCContactController.swift
//  XinChat
//
//  Created by FangLin on 2019/8/6.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit
import NIMSDK

// cellID
fileprivate let XCContactCellID = "XCContactCellID"
// footerH
fileprivate let XCContactFooterH: CGFloat = 49.0
// headerH
fileprivate let XCContactHeaderH: CGFloat = 22.0

class XCContactController: SBaseController {
    
    // MARK:- 懒加载
    // MARK: 功能
    lazy var funcArr: [XCContactCellModel] = {
        return XCUIDataHelper.getContactFuncs()
    }()
    
    lazy var tableView:UITableView = {
        let table = UITableView.init(frame: .zero, style: .plain)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = .white
        let footView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: XCContactFooterH + 0.4))
        footView.backgroundColor = kSplitLineColor
        footView.addSubview(self.footerL)
        table.tableFooterView = footView
        // 改变索引的颜色
        table.sectionIndexColor = UIColor.black
        // 改变索引背景颜色
        table.sectionIndexBackgroundColor = UIColor.clear
        // 改变索引被选中的背景颜色
        table.sectionIndexTrackingBackgroundColor = UIColor.green
        return table
    }()
    
    //MARK:tableFooterView
    lazy var footerL:UILabel = {
        let footer = UILabel.init(frame: CGRect(x: 0, y: 0.45, width: SCREEN_WIDTH, height: XCContactFooterH))
        footer.text = String.init(format: NSLocalizedString("Contact_contacts", comment: ""), 0)
        footer.font = UIFont.systemFont(ofSize: 15)
        footer.backgroundColor = UIColor.white
        footer.textColor = UIColor.gray
        footer.textAlignment = .center
        return footer
    }()
    
    // MARK: 处理过的联系人数组
    lazy var dataArr: [[XCContactCellModel]] = {
        return [[XCContactCellModel]]()
    }()
    
    // MARK: 联系人数组
    var friendArr: [NIMUser]? {
        didSet {
            dataArr.removeAll()
            var arr = [XCContactCellModel]()
            for friend in friendArr! {
                arr.append(XCContactCellModel(user: friend))
            }
            if let count = friendArr?.count {
                footerL.text = String.init(format: NSLocalizedString("Contact_contacts", comment: ""), count)
            }
            
            dataArr = XCContactHepler.getFriendListData(by: arr)
            sectionArr = XCContactHepler.getFriendListSection(by: dataArr)
            
            tableView.reloadData()
        }
    }
    // MARK: 索引数组
    lazy var sectionArr: [String] = {
        return [String]()
    }()
    
    //未读数
    var unReadCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setInterface()
        self.registerNote()
        friendArr = getMyFriends()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getUnReadCount()
    }
    
    func getUnReadCount() {
        var datas = [XCRecentSessionModel]()
        guard let recentSessions = XCXinChatTools.shared.getAllRecentSession() else {
            return
        }
        for session in recentSessions {
            guard let userId = session.session?.sessionId else {return}
            if !XCXinChatTools.shared.isMyFriend(userId) {
                let model = XCRecentSessionModel()
                model.recentSession = session
                datas.append(model)
            }
        }
        // 设置未读数
        var badgCount = 0
        for sessionModel in datas {
            badgCount += sessionModel.unreadCount
        }
//        self.settingBadgeValue(tabbarItem: 1, count: badgCount)
        unReadCount = badgCount
        self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .none)
    }
    
    fileprivate func setInterface() {
        self.view.backgroundColor = .white
        
        //添加tableview
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        // 注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: NSNotification.Name(rawValue: kNoteUserInfoUpdateFriends), object: nil)
        
        tableView.register(UINib.init(nibName: "XCContactCell", bundle: nil), forCellReuseIdentifier: XCContactCellID)
    }
}

// MARK:- 测试
extension XCContactController {
    func getMyFriends() -> [NIMUser]? {
        return XCXinChatTools.shared.getMyFriends()
    }
}

// MARK: - Action
extension XCContactController {
    
    // 刷新表格
    @objc func reloadTableView() {
        friendArr = getMyFriends()
    }
}


extension XCContactController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count+1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return funcArr.count
        }else {
            return dataArr[section-1].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: XCContactCellID, for: indexPath) as! XCContactCell
        var data: XCContactCellModel?
        if indexPath.section == 0 {
            data = funcArr[indexPath.row]
            if indexPath.row == 0 {
                if unReadCount == 0 {
                    cell.tipBadge.isHidden = true
                } else {
                    cell.tipBadge.isHidden = false
                    cell.tipBadge.text = "\(unReadCount)"
                }
            }else {
                cell.tipBadge.isHidden = true
            }
        } else {
            data = dataArr[indexPath.section - 1][indexPath.row]
            cell.tipBadge.isHidden = true
        }
        cell.model = data
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(55*IPONE_SCALE)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var data: XCContactCellModel?
        if indexPath.section == 0 {
            data = funcArr[indexPath.row]
        } else {
            data = dataArr[indexPath.section - 1][indexPath.row]
        }
        
        if indexPath.section == 0 {
            if indexPath.row == 0 { //新的朋友
                let newFriendVC = XCNewFriendController()
                self.navigationController?.pushViewController(newFriendVC, animated: true)
            }
        } else {
            Dprint(data?.userId)
            guard let dataModel = data else {
                return
            }
            let userInfoVC = UserInfoController.init(funcType: .SendMessage)
            userInfoVC.userId = dataModel.userId ?? ""
            userInfoVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(userInfoVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: XCContactHeaderH))
        header.backgroundColor = kSectionColor
        
        let titleL = UILabel(frame: header.bounds)
        titleL.text = self.tableView(tableView, titleForHeaderInSection: section)
        titleL.font = UIFont.systemFont(ofSize: 14.0)
        titleL.x = 10
        header.addSubview(titleL)
        return header
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return XCContactHeaderH
    }
    
    // 返回索引数组
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionArr
    }
    // 返回每个索引的内容
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }
        return sectionArr[section]
    }
    // 跳至对应的section
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if index == 0 {
//            tableView.scrollRectToVisible(searchController!.searchBar.frame, animated: true)
            return -1
        }
        return index
    }
}
