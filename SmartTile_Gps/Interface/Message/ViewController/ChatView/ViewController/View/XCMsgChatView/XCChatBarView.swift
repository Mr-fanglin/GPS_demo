//
//  XCChatBarView.swift
//  XinChat
//
//  Created by FangLin on 2019/10/14.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit

let kChatKeyboardBgColor: UIColor = HEXCOLOR(h: 0xf6f6f6, alpha: 1)
let kChatBarOriginHeight: CGFloat = 49.0+IPHONEX_BH
let kChatBarTextViewMaxHeight: CGFloat = 100
let kChatBarTextViewHeight: CGFloat = kChatBarOriginHeight - 14.0

protocol XCChatBarViewDelegate: NSObjectProtocol {
    func chatBarShowTextKeyboard()
    func chatBarShowVoice()
    func chatBarShowEmotionKeyboard()
    func chatBarShowMoreKeyboard()
    func chatBarUpdateHeight(height: CGFloat)
    func chatBarSendMessage()
}

enum XCChatKeyboardType: Int {
    case nothing
    case voice
    case text
    case emotion
    case more
}

class XCChatBarView: UIView {
    
    // MARK:- 记录属性
    var keyboardType: XCChatKeyboardType = .nothing
    weak var delegate: XCChatBarViewDelegate?
    var inputTextViewCurHeight: CGFloat = kChatBarOriginHeight
    
    lazy var voiceButton:UIButton = {
        let voiceBtn = UIButton.init(type: .custom)
        voiceBtn.addTarget(self, action: #selector(voiceBtnClick(_:)), for: .touchUpInside)
        return voiceBtn
    }()
    
    lazy var emotionButton:UIButton = {
        let emotionBtn = UIButton.init(type: .custom)
        emotionBtn.addTarget(self, action: #selector(emotionBtnClick(_ :)), for: .touchUpInside)
        return emotionBtn
    }()
    
    lazy var moreButton:UIButton = {
        let moreBtn = UIButton.init(type: .custom)
        moreBtn.addTarget(self, action: #selector(moreBtnClick(_ :)), for: .touchUpInside)
        return moreBtn
    }()
    
    lazy var recordButton: UIButton = {
        let recordBtn = UIButton(type: .custom)
        recordBtn.backgroundColor = UIColor.white
        recordBtn.setTitle("按住 说话", for: .normal)
        recordBtn.setTitle("松开 结束", for: .highlighted)
        recordBtn.setBackgroundImage(UIColor.hexInt(0xF3F4F8).trans2Image(), for: .normal)
        recordBtn.setBackgroundImage(UIColor.hexInt(0xC6C7CB).trans2Image(), for: .highlighted)
        recordBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        recordBtn.setTitleColor(UIColor.black, for: .normal)
        recordBtn.setTitleColor(UIColor.black, for: .highlighted)
        recordBtn.layer.cornerRadius = 4.0
        recordBtn.layer.masksToBounds = true
        recordBtn.layer.borderColor = kSplitLineColor.cgColor
        recordBtn.layer.borderWidth = 0.5
        recordBtn.isHidden = true
        return recordBtn
    }()
    
    lazy var inputTextView: UITextView = { [unowned self] in
        let inputV = UITextView()
        inputV.font = UIFont.systemFont(ofSize: 15.0)
        inputV.textColor = UIColor.black
        inputV.returnKeyType = .send
        inputV.enablesReturnKeyAutomatically = true
        //        inputV.textContainerInset = UIEdgeInsetsMake(8, 5, 8, 5)
        inputV.layer.cornerRadius = 4.0
        inputV.layer.masksToBounds = true
//        inputV.layer.borderColor = kSplitLineColor.cgColor
//        inputV.layer.borderWidth = 0.5
        inputV.delegate = self
        inputV.addObserver(self, forKeyPath: "attributedText", options: .new, context: nil)
        return inputV
        }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        // 设置按钮图片
        self.resetBtnsUI()
        // 初始化UI
        self.setUp()
        // 初始化事件
        self.setupEvents()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        inputTextView.removeObserver(self, forKeyPath: "attributedText")
    }
    
}

extension XCChatBarView {
    func setUp() {
        backgroundColor = kChatKeyboardBgColor
        addSubview(voiceButton)
        addSubview(emotionButton)
        addSubview(moreButton)
        addSubview(inputTextView)
        addSubview(recordButton)
        
        // 布局
        voiceButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(5)
            make.width.height.equalTo(35)
            make.bottom.equalTo(self.snp.bottom).offset(-7)
        }
        moreButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right).offset(-5)
            make.width.height.equalTo(35)
            make.bottom.equalTo(self.snp.bottom).offset(-7)
        }
        emotionButton.snp.makeConstraints { (make) in
            make.right.equalTo(moreButton.snp.left)
            make.width.height.equalTo(35)
            make.bottom.equalTo(self.snp.bottom).offset(-7)
        }
        inputTextView.snp.makeConstraints { (make) in
            make.left.equalTo(voiceButton.snp.right).offset(7)
            make.right.equalTo(emotionButton.snp.left).offset(-7)
            make.top.equalTo(self).offset(7)
            make.bottom.equalTo(self).offset(-7)
        }
        recordButton.snp.makeConstraints { (make) in
            make.left.equalTo(voiceButton.snp.right).offset(7)
            make.right.equalTo(emotionButton.snp.left).offset(-7)
            make.height.equalTo(35)
            make.centerY.equalTo(self.snp.centerY)
        }
        // 添加上下两条线(只添加一条)
        for i in 0..<1 {
            let splitLine = UIView()
            splitLine.backgroundColor = kSplitLineColor
            self.addSubview(splitLine)
            if i == 0 {
                splitLine.snp.makeConstraints({ (make) in
                    splitLine.snp.makeConstraints { (make) in
                        make.left.top.right.equalTo(self)
                        make.height.equalTo(0.5)
                    }
                })
            } else {
                splitLine.snp.makeConstraints({ (make) in
                    splitLine.snp.makeConstraints { (make) in
                        make.left.bottom.right.equalTo(self)
                        make.height.equalTo(0.5)
                    }
                })
            }
        }
    }
}

extension XCChatBarView {
    @objc func voiceBtnClick(_ btn: UIButton) {
        resetBtnsUI()
        if keyboardType == .voice { // 正在显示语音
            keyboardType = .text
            
            inputTextView.isHidden = false
            recordButton.isHidden = true
            inputTextView.becomeFirstResponder()
            
        } else {
            keyboardType = .voice
            inputTextView.resignFirstResponder()
            inputTextView.isHidden = true
            recordButton.isHidden = false
            
            voiceButton.setImage(#imageLiteral(resourceName: "ToolViewKeyboard"), for: .normal)
            voiceButton.setImage(#imageLiteral(resourceName: "ToolViewKeyboardHL"), for: .highlighted)
            
            // 调用代理方法
            delegate?.chatBarShowVoice()
            // 改变键盘高度为正常
            delegate?.chatBarUpdateHeight(height: kChatBarOriginHeight)
        }
    }
    
    @objc func emotionBtnClick(_ btn: UIButton) {
        resetBtnsUI()
        if keyboardType == .emotion { // 正在显示表情键盘
            keyboardType = .text
            inputTextView.becomeFirstResponder()
        } else {
            
            if keyboardType == .voice {
                recordButton.isHidden = true
                inputTextView.isHidden = false
                // textViewDidChange
            } else if keyboardType == .text {
                inputTextView.resignFirstResponder()
            }
            
            keyboardType = .emotion
            inputTextView.resignFirstResponder()
            
            emotionButton.setImage(#imageLiteral(resourceName: "ToolViewKeyboard"), for: .normal)
            emotionButton.setImage(#imageLiteral(resourceName: "ToolViewKeyboardHL"), for: .highlighted)
            
            // 调用代理方法
            delegate?.chatBarShowEmotionKeyboard()
        }
    }
    
    @objc func moreBtnClick(_ btn: UIButton) {
        resetBtnsUI()
        if keyboardType == .more { // 正在显示更多键盘
            keyboardType = .text
            inputTextView.becomeFirstResponder()
            
        } else {
            if keyboardType == .voice {
                recordButton.isHidden = true
                inputTextView.isHidden = false
                // textViewDidChange
            } else if keyboardType == .text {
                inputTextView.resignFirstResponder()
            }
            
            keyboardType = .more
            // inputTextView.resignFirstResponder()
            
            moreButton.setImage(#imageLiteral(resourceName: "ToolViewKeyboard"), for: .normal)
            moreButton.setImage(#imageLiteral(resourceName: "ToolViewKeyboardHL"), for: .highlighted)
            
            // 调用代理方法
            delegate?.chatBarShowMoreKeyboard()
        }
    }
    
    fileprivate func setupEvents() {
        // 录音按钮的事件
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(voiceBtnLongTap(_:)))
        recordButton.addGestureRecognizer(longTap)
    }
    
    // 切换 录音按钮的UI
    fileprivate func replaceRecordBtnUI(isRecording: Bool) {
        if isRecording {
            recordButton.setBackgroundImage(UIColor.hexInt(0xC6C7CB).trans2Image(), for: .normal)
            recordButton.setBackgroundImage(UIColor.hexInt(0xF3F4F8).trans2Image(), for: .highlighted)
            recordButton.setTitle("松开 结束", for: .normal)
            recordButton.setTitle("按住 说话", for: .highlighted)
        } else {
            recordButton.setBackgroundImage(UIColor.hexInt(0xF3F4F8).trans2Image(), for: .normal)
            recordButton.setBackgroundImage(UIColor.hexInt(0xC6C7CB).trans2Image(), for: .highlighted)
            recordButton.setTitle("按住 说话", for: .normal)
            recordButton.setTitle("松开 结束", for: .highlighted)
        }
    }
    
    func resetBtnsUI()  {
        voiceButton.setImage(#imageLiteral(resourceName: "ToolViewInputVoice"), for: .normal)
        voiceButton.setImage(#imageLiteral(resourceName: "ToolViewInputVoiceHL"), for: .highlighted)
        
        emotionButton.setImage(#imageLiteral(resourceName: "ToolViewEmotion"), for: .normal)
        emotionButton.setImage(#imageLiteral(resourceName: "ToolViewEmotionHL"), for: .highlighted)
        
        moreButton.setImage(#imageLiteral(resourceName: "TypeSelectorBtn_Black"), for: .normal)
        moreButton.setImage(#imageLiteral(resourceName: "TypeSelectorBtnHL_Black"), for: .highlighted)
        
        // 时刻修改barView的高度
        self.textViewDidChange(inputTextView)
    }
    
    
    @objc func voiceBtnLongTap(_ longTap: UILongPressGestureRecognizer) {
        if longTap.state == .began {    // 长按开始
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNoteChatBarRecordBtnLongTapBegan), object: longTap)
            self.replaceRecordBtnUI(isRecording: true)
        } else if longTap.state == .changed {   // 长按平移
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNoteChatBarRecordBtnLongTapChanged), object: longTap)
        } else if longTap.state == .ended { // 长按结束
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNoteChatBarRecordBtnLongTapEnded), object: longTap)
            self.replaceRecordBtnUI(isRecording: false)
        }
    }
}

extension XCChatBarView: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        resetBtnsUI()
        keyboardType = .text
        // 调用代理方法
        delegate?.chatBarShowTextKeyboard()
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        var height = textView.sizeThatFits(CGSize(width: textView.width, height: CGFloat(FLT_MAX))).height
        height = height > kChatBarTextViewHeight ? height : kChatBarTextViewHeight
        height = height < kChatBarTextViewMaxHeight ? height : textView.height
        inputTextViewCurHeight = height + kChatBarOriginHeight - kChatBarTextViewHeight
        if inputTextViewCurHeight != textView.height {
            UIView.animate(withDuration: 0.05, animations: {
                // 调用代理方法
                self.delegate?.chatBarUpdateHeight(height: self.inputTextViewCurHeight)
            })
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            Dprint("发送")
            delegate?.chatBarSendMessage()
            return false
        }
        return true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        Dprint("文字改变")
        inputTextView.scrollRangeToVisible(NSMakeRange(inputTextView.text.count, 1))
        self.textViewDidChange(inputTextView)
    }
}
