//
//  XCMsgChatListView.swift
//  XinChat
//
//  Created by FangLin on 2019/11/8.
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
fileprivate let XCChatLocationCellID = "XCChatLocationCellID"
fileprivate let XCChatSimpleCellID = "XCChatSimpleCellID"
fileprivate let XCChatOrderCellID = "XCChatOrderCellID"

class XCMsgChatListView: UIView {
    
    // MARK:- 属性
    // MARK: 用户模型
    var user: XCRecentSessionModel?
    
    var dataArr:[XCChatMsgModel] = []{
        didSet{
            if dataArr.count <= 20 {
                self.tableView.mj_header.isHidden = true
            }else {
                self.tableView.mj_header.isHidden = false
            }
            if self.tableView.mj_header.isRefreshing {
                return
            }
            self.scrollToBottom()
        }
    }

    // MARK: 代理
    weak var delegate: XCChatMsgControllerDelegate?
    
    private var tableView:UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
        self.setKeyboardHidesAction()
        // 设置刷新
        let headerRefresh = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadEarlierMsgs))
        headerRefresh?.lastUpdatedTimeLabel.isHidden = true
        headerRefresh?.stateLabel.isHidden = true
        headerRefresh?.arrowView.isHidden = true
        self.tableView.mj_header = headerRefresh
    }
    
    fileprivate func setUp(){
        tableView = UITableView(frame: self.bounds, style: .plain)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = HEXCOLOR(h: 0xededed, alpha: 1)
        // 注册cell
        tableView.register(XCChatTextCell.classForCoder(), forCellReuseIdentifier: XCChatTextCellID)
        tableView.register(XCChatImageCell.classForCoder(), forCellReuseIdentifier: XCChatImageCellID)
        tableView.register(XCChatTimeCell.classForCoder(), forCellReuseIdentifier: XCChatTimeCellID)
        tableView.register(XCChatAudioCell.classForCoder(), forCellReuseIdentifier: XCChatAudioCellID)
        tableView.register(XCChatVideoCell.classForCoder(), forCellReuseIdentifier: XCChatVideoCellID)
        tableView.register(XCChatLocationCell.classForCoder(), forCellReuseIdentifier: XCChatLocationCellID)
        tableView.register(XCChatSimpleCell.classForCoder(), forCellReuseIdentifier: XCChatSimpleCellID)
        tableView.register(XCChatOrderCell.classForCoder(), forCellReuseIdentifier: XCChatOrderCellID)
        self.addSubview(tableView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = self.bounds
        if tableView.contentSize.height > tableView.frame.size.height {
            let offset = CGPoint.init(x: 0, y: tableView.contentSize.height - tableView.frame.size.height)
            tableView.setContentOffset(offset, animated: false)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //设置键盘l隐藏
    func setKeyboardHidesAction() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(keyboardHidesAction))
        tableView.addGestureRecognizer(tap)
    }
}

//MARK: - Action
extension XCMsgChatListView {
    @objc func keyboardHidesAction() {
        delegate?.chatMsgVCWillBeginDragging(chatMsgVC: XCMsgChatListController.init(user: user))
    }
}

// MARK: - 数据源、代理
extension XCMsgChatListView: UITableViewDataSource, UITableViewDelegate {
    // MARK: - UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArr[indexPath.row]
        
        // 时间是特例
        if model.modelType == .time {
            let cell = tableView.dequeueReusableCell(withIdentifier: XCChatTimeCellID) as? XCChatTimeCell
            cell?.model = model
            return cell!
        }else if model.modelType == .addFriendSuc || ((model.sessionId?.contains("system_01"))! && model.modelType == .tip) || model.modelType == .orderTip  {
            let cell = tableView.dequeueReusableCell(withIdentifier: XCChatSimpleCellID) as? XCChatSimpleCell
            cell?.model = model
            return cell!
        }
        
        var cell: XCChatBaseCell?
        if model.modelType == .text || model.modelType == .videoCall {
            cell = tableView.dequeueReusableCell(withIdentifier: XCChatTextCellID) as? XCChatTextCell
        } else if model.modelType == .image {
            cell = tableView.dequeueReusableCell(withIdentifier: XCChatImageCellID) as? XCChatImageCell
        } else if model.modelType == .audio {
            cell = tableView.dequeueReusableCell(withIdentifier: XCChatAudioCellID) as? XCChatAudioCell
        } else if model.modelType == .video {
            cell = tableView.dequeueReusableCell(withIdentifier: XCChatVideoCellID) as? XCChatVideoCell
        }else if model.modelType == .location {
            cell = tableView.dequeueReusableCell(withIdentifier: XCChatLocationCellID) as? XCChatLocationCell
        }else if model.modelType == .helpPick || model.modelType == .agreePick || model.modelType == .askingPick || model.modelType == .requestPick{
            cell = tableView.dequeueReusableCell(withIdentifier: XCChatOrderCellID) as? XCChatOrderCell
        }
        cell?.model = model
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataArr[indexPath.row]
        if model.modelType == .location {
            return CGFloat(158*IPONE_SCALE)
        }else if model.modelType == .addFriendSuc || ((model.sessionId?.contains("system_01"))! && model.modelType == .tip) {
            return CGFloat(20*IPONE_SCALE)
        }
        if model.cellHeight == 0 {
            _ = self.tableView.cellForRow(at: indexPath)
        }
        return model.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //键盘落下
        delegate?.chatMsgVCWillBeginDragging(chatMsgVC: XCMsgChatListController.init(user: user))
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.chatMsgVCWillBeginDragging(chatMsgVC: XCMsgChatListController.init(user: user))
    }
}

// MARK:- 刷新加载更多
extension XCMsgChatListView {
    @objc func loadEarlierMsgs() {
        Dprint("加载更早的消息")
        let earlierMsgs = XCXinChatTools.shared.getLocalMsgs(userId: user?.userId, message: dataArr.first?.message)
        guard let eMsgs = earlierMsgs else {
            return
        }
        // 没有本地消息了
        if eMsgs.count == 0 {
            var curMessage: NIMMessage? = nil
            if dataArr.count != 0 {
                curMessage = dataArr[1].message
            }
            // 加载云端消息
            XCXinChatTools.shared.getCloudMsgs(currentMessage: curMessage, userId: user?.userId, resultBlock: { (error, messages) in
                if error != nil {
                    Dprint(error)
                    self.tableView.mj_header.endRefreshing()
                } else {
                    guard let msgs = messages, msgs.count != 0 else {
                        self.tableView.mj_header.endRefreshing()
                        self.tableView.mj_header.isHidden = true
                        return
                    }
                    self.loadMoreMessage(msgs: msgs)
                    self.tableView.mj_header.endRefreshing()
                }
            })
        } else { // 加载更多本地消息
            self.loadMoreMessage(msgs: eMsgs)
        }
    }
    
    fileprivate func loadMoreMessage(msgs: [NIMMessage]) {
        let models = XCChatMsgDataHelper.shared.getFormatMsgs(nimMsgs: msgs)
        let timeMsgs = XCChatMsgDataHelper.shared.addTimeModel(models: models)
        var indexPath: IndexPath!
        if dataArr.count == 0 {
            indexPath = IndexPath(row: timeMsgs.count - 1, section: 0)
        } else {
            indexPath = IndexPath(row: timeMsgs.count, section: 0)
        }
        for timeMsg in timeMsgs.reversed() {
            self.insertRowModel(model: timeMsg, isBottom: false)
        }
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        self.tableView.mj_header.endRefreshing()
    }
}

// MARK:- 对外提供的方法
extension XCMsgChatListView {
    // MARK: 滚到底部
    func scrollToBottom(animated: Bool = false) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            if self.dataArr.count > 0 {
                let indexPath = IndexPath(row: self.dataArr.count-1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }
    // MARK: 插入模型数据
    func insertRowModel(model: XCChatMsgModel, isBottom: Bool = true) {
        var indexPath: IndexPath!
        if isBottom {
            dataArr.append(model)
            indexPath = IndexPath(row: dataArr.count - 1, section: 0)
            _ = self.tableView(tableView, cellForRowAt: indexPath)
            self.insertRows([indexPath])
        } else {
            dataArr.insert(model, at: 0)
            indexPath = IndexPath(row: 0, section: 0)
            _ = self.tableView(tableView, cellForRowAt: indexPath)
            self.insertRows([indexPath], atBottom: false)
        }
    }
    // MARK:更新模型数据
    func updateRowModel(model: XCChatMsgModel) {
        for dataModel in dataArr {
            if model.message != dataModel.message { continue }
            let indexPath = IndexPath(row: dataArr.index(of: dataModel)!, section: 0)
            self.updataRow([indexPath])
        }
    }
    // MARK:删除模型数据
    func deleteRowModel(model: XCChatMsgModel) {
        var index = 0
        for dataModel in dataArr {
            if (model.message == dataModel.message) && (dataModel.modelType != .time) {
                let indexPath = IndexPath(row: dataArr.index(of: dataModel)!, section: 0)
                dataArr.remove(at: index)
                self.deleteRow([indexPath])
                return
            }
            index += 1
        }
    }
}

// MARK:- private Method
extension XCMsgChatListView {
    // MARK: 插入数据
    fileprivate func insertRows(_ rows: [IndexPath], atBottom: Bool = true) {
        UIView.setAnimationsEnabled(false)
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: rows, with: .none)
        self.tableView.endUpdates()
        if atBottom {
            self.scrollToBottom()
        }
        UIView.setAnimationsEnabled(true)
        Dprint("插入数据")
    }
    
    // MARK: 更新数据
    fileprivate func updataRow(_ rows: [IndexPath]) {
        UIView.setAnimationsEnabled(false)
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: rows, with: .none)
        self.tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        Dprint("更新数据")
    }
    
    // MARK: 删除数据
    fileprivate func deleteRow(_ rows: [IndexPath]) {
        UIView.setAnimationsEnabled(false)
        self.tableView.beginUpdates()
        self.tableView.deleteRows(at: rows, with: .none)
        self.tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        Dprint("删除数据")
    }
}
