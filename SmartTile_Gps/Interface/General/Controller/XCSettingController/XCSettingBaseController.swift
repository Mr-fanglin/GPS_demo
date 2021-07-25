//
//  XCSettingBaseController.swift
//  XinChat
//
//  Created by FangLin on 2019/10/16.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit

fileprivate let cellH: CGFloat = 44.0
fileprivate let XCSettingSimpleNorCellID = "XCSettingSimpleNorCellID"
fileprivate let XCSettingAvatarCellID = "XCSettingAvatarCellID"
fileprivate let XCSettingSimpleMidCellID = "XCSettingSimpleMidCellID"
fileprivate let XCSettingLeftCellID = "XCSettingLeftCellID"

class XCSettingBaseController: SBaseController {

    // MARK:- 标记属性
    var isAvatar: Bool = false
    var isSubAvatar: Bool = false
    
    // MARK:- 懒加载
    // tableView
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = kNavBarBgColor
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // models
    lazy var models: [[XCSettingCellModel]] = {
        return [[XCSettingCellModel]]()
    }()
    
    // MARK:- 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        self.setup()
    }
}

// MARK:- 初始化
extension XCSettingBaseController {
    fileprivate func setup() {
        
        // 注册cellID
        tableView.register(XCSettingSimpleNorCell.self, forCellReuseIdentifier: XCSettingSimpleNorCellID)
        tableView.register(XCSettingAvatarCell.self, forCellReuseIdentifier: XCSettingAvatarCellID)
        tableView.register(XCSettingSimpleMidCell.self, forCellReuseIdentifier: XCSettingSimpleMidCellID)
        tableView.register(XCSettingLeftCell.self, forCellReuseIdentifier: XCSettingLeftCellID)
        
        // 添加tableView
        view.addSubview(self.tableView)
    }
}

extension XCSettingBaseController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.models[indexPath.section][indexPath.row]
        var cell: XCSettingBaseCell?
        var cellID: String!
        if model.type == .avatar {
            cellID = XCSettingAvatarCellID
        } else if model.type == .middle {
            cellID = XCSettingSimpleMidCellID
        } else if model.type == .left {
            cellID = XCSettingLeftCellID
        } else {
            cellID = XCSettingSimpleNorCellID
        }
        cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? XCSettingBaseCell
        
        // 设置数据
        cell?.model = model
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0  && isAvatar {   // 头像
            return CGFloat(140*IPONE_SCALE)
        } else if indexPath.section == 0 && indexPath.row == 0  && isSubAvatar {
            return cellH * 2 - 8
        }
        return CGFloat(55*IPONE_SCALE)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.models[indexPath.section][indexPath.row]
        if model.title == "设置" {
            
        }else if model.title == "退出登录" {
            let alertVC = UIAlertController.initSheetView(sureTitle: "确定退出登录") { (alert) in
                XCXinChatTools.shared.loginOut()
            }
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(8*IPONE_SCALE)
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let bgView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: CGFloat(8*IPONE_SCALE)))
        bgView.backgroundColor = kNavBarBgColor
        return bgView
    }
}

extension XCSettingBaseController {
    func pushViewController(_ controller: UIViewController, isHidesBottomBarWhenPushed isHeide: Bool = true) {
        controller.hidesBottomBarWhenPushed = isHeide
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension XCSettingBaseController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}

