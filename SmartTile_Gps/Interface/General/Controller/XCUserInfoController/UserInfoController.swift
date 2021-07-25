//
//  UserInfoController.swift
//  XinChat
//
//  Created by FangLin on 2019/10/17.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit

fileprivate let UserInfoCellID = "UserInfoCellID"
fileprivate let UserInfoFuncCellID = "UserInfoFuncCellID"
fileprivate let UserInfoSetAliasCellID = "UserInfoSetAliasCellID"

enum UserInfoFuncType {
    case none
    case SendMessage   //发消息，音视频通话
    case AddBook      //添加到通讯录
    case PassVerify   //通过验证
}

class UserInfoController: SBaseController {
    
    var userId:String = ""
    
    //设置白色背景
    fileprivate var tableWhiteBgView:UIView = UIView.init()
    lazy var tableView:UITableView = {
        let table = UITableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = kNavBarBgColor
        return table
    }()
    
    lazy var userInfo: XCContactCellModel = {
        return XCContactCellModel.init(user: XCXinChatTools.shared.getFriendInfo(userId: userId))
    }()
    
    var funcArr:[XCSettingCellModel] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    var funcType:UserInfoFuncType = .none {
        didSet{
            self.setFuncType(type: funcType)
        }
    }
    
    //MARK: - init
    init(funcType:UserInfoFuncType) {
        super.init(nibName: nil, bundle: nil)
        self.setFuncType(type: funcType)
    }
    
    func setFuncType(type:UserInfoFuncType) {
        if type == .SendMessage {
            funcArr = XCUIDataHelper.getUserInfoFunc(dataArr: [" 发消息"," 音视频通话"],images: ["AlbumCommentSingleAHL","ChatRoom_Bubble_VOIP_Video"])
        }else if type == .AddBook {
            funcArr = XCUIDataHelper.getUserInfoFunc(dataArr: ["添加到通讯录"],images: nil)
        }else if type == .PassVerify {
            funcArr = XCUIDataHelper.getUserInfoFunc(dataArr: ["通过验证"],images: nil)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
//        self.navBarTintColor = .white
        self.createNavbar(navTitle: "个人名片", leftImage: nil, rightImage: nil, ringhtAction: nil)
        self.setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: NSNotification.Name(rawValue: kNoteUserInfoUpdateFriends), object: nil)
    }
    
    fileprivate func setUp() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(NEWNAVHEIGHT)
        }
        tableView.register(UserInfoCell.classForCoder(), forCellReuseIdentifier: UserInfoCellID)
        tableView.register(UserInfoFuncCell.classForCoder(), forCellReuseIdentifier: UserInfoFuncCellID)
        tableView.register(UserInfoSetAliasCell.classForCoder(), forCellReuseIdentifier: UserInfoSetAliasCellID)
        
        tableWhiteBgView.backgroundColor = .white
        self.view.addSubview(tableWhiteBgView)
        tableWhiteBgView.snp.makeConstraints { (make) in
            make.top.equalTo(NEWNAVHEIGHT)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}

/// Notification
extension UserInfoController {
    @objc func reloadTableView() {
        userInfo = XCContactCellModel.init(user: XCXinChatTools.shared.getFriendInfo(userId: userId))
        self.tableView.reloadData()
    }
}

extension UserInfoController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let bgView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: CGFloat(8*IPONE_SCALE)))
        bgView.backgroundColor = kNavBarBgColor
        return bgView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }else {
            return funcArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoCellID) as? UserInfoCell
                cell?.model = userInfo
                return cell!
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoSetAliasCellID) as? UserInfoSetAliasCell
                return cell!
            }
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoFuncCellID) as? UserInfoFuncCell
            let model = funcArr[indexPath.row]
            cell?.model = model
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            let model = funcArr[indexPath.row]
            switch model.title {
            case "添加到通讯录":
                XCProgressHUD.XC_showWithStatus("正在添加...")
                let mineInfo = XCXinChatTools.shared.getMineInfo()
                guard let mineUserId = mineInfo?.userId else {
                    return
                }
                XCXinChatTools.shared.addFriend(userInfo.userId ?? "", message: "我是"+(mineInfo?.alias ?? mineInfo?.userInfo?.nickName ?? mineUserId)) { (error) in
                    if error != nil {
                        XCProgressHUD.XC_showError(withStatus: "用户不存在")
                    }else {
                        XCProgressHUD.XC_showSuccess(withStatus: "添加好友成功")
                        XCXinChatTools.shared.sendAddFriendRequest(userId: self.userInfo.userId ?? "", postscript: "我是"+(mineInfo?.alias ?? mineInfo?.userInfo?.nickName ?? mineUserId))
                    }
                }
//                XCXinChatTools.shared.requstAddFriend(userInfo.userId ?? "", message: "我是"+(mineInfo?.alias ?? mineInfo?.userInfo?.nickName ?? mineUserId)) { (error) in
//                    if error != nil {
//                        XCProgressHUD.XC_showError(withStatus: "用户不存在")
//                    }else {
//                        XCProgressHUD.XC_showSuccess(withStatus: "好友请求发送成功，等待对方验证")
//                        XCXinChatTools.shared.sendAddFriendRequest(userId: self.userInfo.userId ?? "", postscript: "我是"+(mineInfo?.alias ?? mineInfo?.userInfo?.nickName ?? mineUserId))
//                    }
//                }
                break
            case " 发消息":
                let msgChatVC = XCMsgChatController.init(user: XCContactCellModel.getrecentSessionModel(userInfo))
                navigationController?.pushViewController(msgChatVC, animated: true)
                break
            case " 音视频通话":
                break
            case "通过验证":
                XCXinChatTools.shared.verifyAddFriend(userId, message: "同意好友添加") { (error) in
                    if error == nil {
                        XCXinChatTools.shared.addFriend(self.userId, message: "", completion: { (error) in
                            if error == nil {
                                self.setFuncType(type: .SendMessage)
                            }
                            
                        })
                    }
                }
                break
            default:
                break
            }
        }else if indexPath.section == 0 {
            if indexPath.row == 1 {  //设置备注
                let aliasVC = SettingAliasController.init(userInfo: userInfo)
                self.present(aliasVC, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return CGFloat(100*IPONE_SCALE)
            }else {
                return CGFloat(50*IPONE_SCALE)
            }
        }else {
            return CGFloat(50*IPONE_SCALE)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(8*IPONE_SCALE)
    }
}

extension UserInfoController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yoffset = scrollView.contentOffset.y
        if yoffset < 0 {
            tableWhiteBgView.snp.remakeConstraints { (make) in
                make.top.equalTo(NEWNAVHEIGHT)
                make.left.right.equalToSuperview()
                make.height.equalTo(-yoffset)
            }
        }else {
            tableWhiteBgView.snp.remakeConstraints { (make) in
                make.top.equalTo(NEWNAVHEIGHT)
                make.left.right.equalToSuperview()
                make.height.equalTo(1)
            }
        }
    }
}

