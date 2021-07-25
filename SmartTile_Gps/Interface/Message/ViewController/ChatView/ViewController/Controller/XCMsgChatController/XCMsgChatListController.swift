//
//  XCMsgChatListController.swift
//  XinChat
//
//  Created by FangLin on 2019/10/14.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit
import MJRefresh
import NIMSDK

// cellID
fileprivate let XCChatTextCellID = "XCChatTextCellID"
fileprivate let XCChatImageCellID = "XCChatImageCellID"
fileprivate let XCChatTimeCellID = "XCChatTimeCellID"
fileprivate let XCChatAudioCellID = "XCChatAudioCellID"
fileprivate let XCChatVideoCellID = "XCChatVideoCellID"

protocol XCChatMsgControllerDelegate: NSObjectProtocol {
    func chatMsgVCWillBeginDragging(chatMsgVC: XCMsgChatListController)
}

///消息列表控制器
class XCMsgChatListController: UIViewController {

    // MARK:- 属性
    // MARK: 用户模型
    var user: XCRecentSessionModel?
    
    lazy var msgListView:XCMsgChatListView = {
        let listV = XCMsgChatListView.init(frame: self.view.bounds)
        return listV
    }()
    
    // MARK:- init
    init(user: XCRecentSessionModel?) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初始化
        setup()
        setDatasource()
    }
    
    fileprivate func setDatasource() {
        let history = XCXinChatTools.shared.getLocalMsgs(userId: self.user?.userId)
        let models = XCChatMsgDataHelper.shared.getFormatMsgs(nimMsgs: history)
        msgListView.dataArr = XCChatMsgDataHelper.shared.addTimeModel(models: models)
        msgListView.user = user
    }
    
    deinit {
        // 移除通知
        NotificationCenter.default.removeObserver(self)
        XCXinChatTools.shared.currentChatUserId = nil
    }

}

// MARK:- 初始化
extension XCMsgChatListController {
    // MARK: 初始
    fileprivate func setup() {
        self.view.addSubview(msgListView)
        msgListView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        // 设置当前聊天的userId
        XCXinChatTools.shared.currentChatUserId = user?.userId
        
        // 注册通知
        self.registerNote()
    }
}

