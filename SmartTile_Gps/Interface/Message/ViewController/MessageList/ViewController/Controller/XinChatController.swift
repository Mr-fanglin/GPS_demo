//
//  XinChatController.swift
//  XinChat
//
//  Created by FangLin on 2019/8/6.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit

class XinChatController: SBaseController,UITableViewDelegate,UITableViewDataSource {
    
    // dataArr
    var dataArr: [XCRecentSessionModel] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    // tableView
    lazy var tableView: UITableView = { [unowned self] in
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView.init(frame: .zero)
        return tableView
    }()
    
    var bgImg = UIImageView.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setInterface()
        self.registerNote()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getSessionsList()
    }
    
    func getSessionsList() {
        var datas = [XCRecentSessionModel]()
        guard let recentSessions = XCXinChatTools.shared.getAllRecentSession() else {
            return
        }
        for session in recentSessions {
            guard let userId = session.session?.sessionId else {return}
            if XCXinChatTools.shared.isMyFriend(userId) || userId.contains("system") {
                let model = XCRecentSessionModel()
                model.recentSession = session
                datas.append(model)
            }
        }
        dataArr = datas
        
        // 设置未读数
        var badgCount = 0
        for sessionModel in dataArr {
            badgCount += sessionModel.unreadCount
        }
        self.settingBadgeValue(tabbarItem: 1, count: badgCount)
    }
    
    func setInterface() {
        self.view.backgroundColor = .white
        
        // 添加tableView
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        // 注册cellID
        tableView.register(XCRecentSessionCell.self, forCellReuseIdentifier: "XCRecentSessionCell")
        
        bgImg.image = UIImage.init(named: "boot page_bg")
        tableView.addSubview(bgImg)
        bgImg.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(350*IPONE_SCALE)
        }
    }
    
    @objc func popMenu(_ sender: UIButton) {
        
    }
    
    //MARK: - UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataArr.count == 0 {
            bgImg.isHidden = false
        }else {
            bgImg.isHidden = true
        }
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "XCRecentSessionCell") as? XCRecentSessionCell
        let model = dataArr[indexPath.row]
        cell?.model = model
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let msgChatVC = XCMsgChatController.init(user: dataArr[indexPath.row])
        msgChatVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(msgChatVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(70*IPONE_SCALE)
    }
}

