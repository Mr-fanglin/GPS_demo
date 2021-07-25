//
//  XCMsgChatController.swift
//  XinChat
//
//  Created by FangLin on 2019/10/14.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

///消息主界面
class XCMsgChatController: SBaseController {

    // MARK:- 记录属性
    var finishRecordingVoice: Bool = true   // 决定是否停止录音还是取消录音
    // MARK:- 用户模型
    var user: XCRecentSessionModel?
    // MARK:- 懒加载
    // MARK: 输入栏控制器
    lazy var chatBarVC: XCMsgChatBarController = { [unowned self] in
        let barVC = XCMsgChatBarController(user: self.user)
        self.view.addSubview(barVC.view)
        barVC.view.snp.makeConstraints { (make) in
            make.left.right.width.equalTo(self.view)
            make.bottom.equalTo(self.view.snp.bottom)
            make.height.equalTo(kChatBarOriginHeight)
        }
        barVC.delegate = self
        return barVC
        }()
    // MARK: 消息列表控制器
    lazy var chatMsgVC: XCMsgChatListController = { [unowned self] in
        let msgVC = XCMsgChatListController(user: self.user)
        self.view.addSubview(msgVC.view)
        msgVC.view.snp.makeConstraints { (make) in
            make.top.equalTo(NEWNAVHEIGHT)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.chatBarVC.view.snp.top)
        }
        msgVC.user = self.user
        msgVC.msgListView.delegate = self
        return msgVC
        }()
    // MARK: 表情面板
    lazy var emotionView: XCChatEmotionView = { [unowned self] in
        let emotionV = XCChatEmotionView()
        emotionV.delegate = self.chatBarVC as? XCChatEmotionViewDelegate
        return emotionV
        }()
    // MARK: 更多面板
    lazy var moreView: XCChatMoreView = { [unowned self] in
        let moreV = XCChatMoreView()
        moreV.delegate = self.chatBarVC as? XCChatMoreViewDelegate
        return moreV
        }()
    // MARK: 录音视图
    lazy var recordVoiceView: XCChatVoiceView = {
        let recordVoiceV = XCChatVoiceView()
        recordVoiceV.isHidden = true
        return recordVoiceV
    }()
    
    // MARK:- init
    init(user: XCRecentSessionModel?) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = kChatKeyboardBgColor//HEXCOLOR(h: 0xededed, alpha: 1)
        self.setInterface()
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //MARK: - 标记为已读
        XCXinChatTools.shared.markAllMessagesReadInSession(userId: user?.userId)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    func setInterface() {
        
        self.createNavbar(navTitle: user?.title ?? "", leftImage: nil, rightImage: nil, ringhtAction: nil)
        
        self.addChild(chatBarVC)
        self.addChild(chatMsgVC)
        
        // 添加表情面板和更多面板
        self.view.addSubview(emotionView)
        self.view.addSubview(moreView)
        self.view.addSubview(recordVoiceView)
        
        // 布局
        emotionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.bottom)
            make.left.right.equalTo(self.view)
            make.height.equalTo(kNoTextKeyboardHeight)
        }
        moreView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.height.equalTo(kNoTextKeyboardHeight)
            make.top.equalTo(self.view.snp.bottom)
        }
        recordVoiceView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(100)
            make.bottom.equalTo(self.view.snp.bottom).offset(-100)
            make.left.right.equalTo(self.view)
        }
        
        //导航栏下划线
        let navLineV = UIView.init()
        navLineV.backgroundColor = HEXCOLOR(h: 0xDEDEDE, alpha: 1)
        self.view.addSubview(navLineV)
        navLineV.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(NEWNAVHEIGHT)
            make.height.equalTo(0.5)
        }
        
        // 注册通知
        self.registerNote()
        XCXinChatTools.shared.mediaDelegate = self
    }
    
    // 注册通知
    fileprivate func registerNote() {
        NotificationCenter.default.addObserver(self, selector: #selector(chatBarRecordBtnLongTapBegan(_ :)), name: NSNotification.Name(rawValue: kNoteChatBarRecordBtnLongTapBegan), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(chatBarRecordBtnLongTapChanged(_ :)), name: NSNotification.Name(rawValue: kNoteChatBarRecordBtnLongTapChanged), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(chatBarRecordBtnLongTapEnded(_ :)), name: NSNotification.Name(rawValue: kNoteChatBarRecordBtnLongTapEnded), object: nil)
    }
    
}

// MARK:- 自身事件处理
extension XCMsgChatController {
    // MARK: 右上角按钮点击事件
    @objc func userInfo() {
        Dprint("查看用户信息")
        chatMsgVC.msgListView.scrollToBottom(animated: true)
        guard let userModel = user else {
            return
        }
        let userInfoVC = UserInfoController.init(funcType: .SendMessage)
        userInfoVC.userId = userModel.userId ?? ""
        userInfoVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(userInfoVC, animated: true)
    }
    
    // MARK: 重置barView的位置
    func resetChatBarFrame() {
        if chatBarVC.keyboardType == .voice {
            return
        }
        chatBarVC.resetKeyboard()
        UIApplication.shared.keyWindow?.endEditing(true)
        chatBarVC.view.snp.updateConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom)
        }
        moreView.snp.updateConstraints { (make) in
            make.top.equalTo(self.view.snp.bottom)
        }
        emotionView.snp.updateConstraints { (make) in
            make.top.equalTo(self.view.snp.bottom)
        }
        UIView.animate(withDuration: kKeyboardChangeFrameTime, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    /* ============================== 录音按钮长按事件 ============================== */
    @objc func chatBarRecordBtnLongTapBegan(_ note : Notification) {
        // Dprint("长按开始")
        finishRecordingVoice = true
        recordVoiceView.recording()
        // 开始录音
        XCXinChatTools.shared.recordVoice()
    }
    @objc func chatBarRecordBtnLongTapChanged(_ note : Notification) {
        // Dprint("长按平移")
        let longTap = note.object as! UILongPressGestureRecognizer
        let point = longTap.location(in: self.recordVoiceView)
        if recordVoiceView.point(inside: point, with: nil) {
            recordVoiceView.slideToCancelRecord()
            finishRecordingVoice = false
        } else {
            recordVoiceView.recording()
            finishRecordingVoice = true
        }
    }
    @objc func chatBarRecordBtnLongTapEnded(_ note : Notification) {
        // Dprint("长按结束")
        if finishRecordingVoice {
            // 停止录音
            XCXinChatTools.shared.stopRecordVoice()
        } else {
            // 取消录音
            XCXinChatTools.shared.cancelRecordVoice()
        }
        recordVoiceView.endRecord()
    }
}

