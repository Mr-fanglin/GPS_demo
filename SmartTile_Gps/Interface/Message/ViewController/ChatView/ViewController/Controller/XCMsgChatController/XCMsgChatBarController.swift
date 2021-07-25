//
//  XCMsgChatBarController.swift
//  XinChat
//
//  Created by FangLin on 2019/10/14.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit

let kKeyboardChangeFrameTime: TimeInterval = 0.25
let kNoTextKeyboardHeight: CGFloat = 216.0 + IPHONEX_BH

protocol XCMsgChatBarControllerDelegate : NSObjectProtocol {
    /* ============================= barView =============================== */
    func chatBarShowTextKeyboard()
    func chatBarShowVoice()
    func chatBarShowEmotionKeyboard()
    func chatBarShowMoreKeyboard()
    func chatBarUpdateHeight(height: CGFloat)
    func chatBarVC(chatBarVC: XCMsgChatBarController, didChageChatBoxBottomDistance distance: CGFloat)
}
///消息输入框控制器
class XCMsgChatBarController: UIViewController {

    var user: XCRecentSessionModel?
    // MARK:- 记录属性
    var keyboardFrame: CGRect?
    var keyboardType: XCChatKeyboardType?
    
    // MARK:- 代理
    weak var delegate: XCMsgChatBarControllerDelegate?
    
    lazy var imgPickerVC: TZImagePickerController = { [unowned self] in
        return TZImagePickerController(maxImagesCount: 9, columnNumber: 4, delegate: self)
    }()
    
    lazy var videoVC: KZVideoViewController = { [unowned self] in
        let videoVC = KZVideoViewController()
        videoVC.delegate = self
        // videoVC.startAnimation(with: .small)
        return videoVC
    }()
    
    // MARK:- 懒加载
    lazy var barView : XCChatBarView = { [unowned self] in
        let barView = XCChatBarView()
        barView.delegate = self
        return barView
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
        view.backgroundColor = kChatKeyboardBgColor
        view.addSubview(barView)
        barView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(50)
        }
        
        // 监听键盘
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

}

// MARK:- 键盘监听事件
extension XCMsgChatBarController {
    @objc fileprivate func keyboardWillHide(_ note: NSNotification) {
        keyboardFrame = CGRect.zero
        if barView.keyboardType == .emotion || barView.keyboardType == .more {
            return
        }
        delegate?.chatBarVC(chatBarVC: self, didChageChatBoxBottomDistance: 0)
    }
    
    @objc fileprivate func keyboardFrameWillShow(_ note: NSNotification) {
        keyboardFrame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect?
        Dprint(keyboardFrame)
        if barView.keyboardType == .emotion || barView.keyboardType == .more {
            return
        }
        delegate?.chatBarVC(chatBarVC: self, didChageChatBoxBottomDistance: keyboardFrame!.height-IPHONEX_BH)
    }
}

// MARK:- 对外提供的方法
extension XCMsgChatBarController {
    func resetKeyboard() {
        barView.resetBtnsUI()
        barView.keyboardType = .nothing
    }
}

// MARK:- 发送信息
extension XCMsgChatBarController {
    func sendMessage() {
        
        // 取出字符串
        let message = barView.inputTextView.getEmotionString()
        barView.inputTextView.text = ""

        // 发送
        XCXinChatTools.shared.sendText(userId: user?.userId, text: message)
        Dprint(message)
    }
}


