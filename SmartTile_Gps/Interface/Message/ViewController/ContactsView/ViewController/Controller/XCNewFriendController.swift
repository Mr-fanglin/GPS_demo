//
//  XCNewFriendController.swift
//  XinChat
//
//  Created by FangLin on 2019/12/4.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit

// cellID
fileprivate let XCNewFriendCellID = "XCNewFriendCellID"

class XCNewFriendController: SBaseController {
    
    // dataArr
    var dataArr: [XCNewFriendMsgModel] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    lazy var tableView:UITableView = {
        let tbView = UITableView.init(frame: .zero, style: .plain)
        tbView.separatorStyle = .none
        tbView.dataSource = self
        tbView.delegate = self
        tbView.backgroundColor = kNavBarBgColor
        return tbView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getSessionsList()
    }
    
    func getSessionsList() {
        if self.dataArr.count != 0 {
            self.dataArr.removeAll()
        }
        guard let recentSessions = XCXinChatTools.shared.getAllRecentSession() else {
            return
        }
        for session in recentSessions {
            guard let userId = session.session?.sessionId else {return}
            let isMyFriend = XCXinChatTools.shared.isMyFriend(userId)
            XCXinChatTools.shared.searchLocalMsg(type: .custom, userId: session.session?.sessionId) { (error, msgArrs) in
                guard let msgArrs = msgArrs else { return }
                for message in msgArrs.reversed() {
                    guard let obj:NIMCustomObject = message.messageObject as? NIMCustomObject else{
                        return
                    }
                    guard let attachment = obj.attachment else { return }
                    if attachment is XCNIMAddFriendRequestAttachment {
                        let model = XCNewFriendMsgModel()
                        model.recentSession = session
                        model.assignMessage = message
                        model.unreadCount = 1
                        model.isAdd = isMyFriend
                        self.dataArr.append(model)
                        break
                    }
                }
            }
            if !isMyFriend {
                //MARK: - 标记为已读
                XCXinChatTools.shared.markAllMessagesReadInSession(userId: userId)
            }
        }
    }

    fileprivate func setUp() {
        self.view.backgroundColor = kNavBarBgColor
        self.createNavbar(navTitle: NSLocalizedString("Contact_NewFriend", comment: ""), leftImage: nil, rightStr: nil, ringhtAction: nil)
        
        // 添加tableView
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(NEWNAVHEIGHT)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        tableView.register(UINib.init(nibName: "XCNewFriendCell", bundle: nil), forCellReuseIdentifier: XCNewFriendCellID)
    }
}

extension XCNewFriendController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: XCNewFriendCellID, for: indexPath) as! XCNewFriendCell
        let model = dataArr[indexPath.row]
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(55*IPONE_SCALE)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArr[indexPath.row]
        guard let userId = model.userId else {
            return
        }
        let userInfoVC = UserInfoController.init(funcType: .PassVerify)
        userInfoVC.userId = userId
        self.navigationController?.pushViewController(userInfoVC, animated: true)
    }
   
}
