//
//  XCUIDataHelper.swift
//  
//
//  Created by FangLin on 2019/12/29.
//  Copyright © 2019年 FangLin. All rights reserved.
//

import UIKit

class XCUIDataHelper: NSObject {
    
    // MARK:- 通讯录
    class func getContactFuncs() -> [XCContactCellModel] {
        return [
            XCContactCellModel(title: NSLocalizedString("Contact_NewFriend", comment: ""), image: "contacts_message_notice"),
        ]
    }
    
    //MARK: - 添加好友
    class func addFriendFuncs() -> [XCContactCellModel]{
        return [
            XCContactCellModel(title: NSLocalizedString("Contact_AddFriend", comment: ""), image: ""),
            XCContactCellModel(title: NSLocalizedString("Contact_CreateTrustGroup", comment: ""), image: "")
        ]
    }
    
    // MARK:- 发现
    class func getFindVC(items: @escaping (_ icons: [[UIImage]], _ titles: [[String]])->Void) {
        // cell图标数组
        let mineCellIcons: [[UIImage]] = [
            [#imageLiteral(resourceName: "ff_IconShowAlbum")],
            [#imageLiteral(resourceName: "ff_IconQRCode"), #imageLiteral(resourceName: "ff_IconShake")],
            [#imageLiteral(resourceName: "ff_IconLocationService")],
            [#imageLiteral(resourceName: "ff_IconShoppingBag"), #imageLiteral(resourceName: "MoreGame")]
        ]
        // cell标题数组
        let mineCellTitles: [[String]] = [
            ["朋友圈"],
            ["扫一扫", "摇一摇"],
            ["附近的人"],
            ["购物", "游戏"]
        ]
        items(mineCellIcons, mineCellTitles)
    }
    
    // MARK: 添加朋友页面
    class func getAddFriendFunc() -> [XCSettingCellModel] {
//        let mineInfo = XCXinChatTools.shared.getMineInfo()
//        let userId = mineInfo?.userId ?? "未设置"
        return [
//            XCSettingCellModel(icon: nil, title: "我的账号："+userId, subTitle:nil, tipImg: "add_friend_myQR", type: .middle),
//            XCSettingCellModel(icon: "add_friend_icon_addgroup", title: "面对面建群", subTitle:"与身边的朋友进入同一个群聊", tipImg:nil, type: .default),
//            XCSettingCellModel(icon: "add_friend_icon_contacts", title: "手机联系人", subTitle:"添加通讯录中的朋友", tipImg:nil, type: .default),
//            XCSettingCellModel(icon: "add_friend_icon_scanqr", title: "扫一扫", subTitle:"扫描二维码名片", tipImg:nil, type: .default)
        ]
    }
    
    //MARK: 个人信息页面
    class func getUserInfoFunc(dataArr:[String],images:[String]?) -> [XCSettingCellModel] {
        var funcArr:[XCSettingCellModel] = []
        for (index,funcStr) in dataArr.enumerated() {
            var imageStr = ""
            if let images = images {
                imageStr = images[index]
            }else {
                imageStr = ""
            }
            let model = XCSettingCellModel.init(icon: imageStr, title: funcStr, subTitle: nil, tipImg: nil)
            funcArr.append(model)
        }
        return funcArr
    }
    
    // MARK: 我
    class func getMineVCData() -> [XCContactCellModel] {
        return [
            XCContactCellModel(title: NSLocalizedString("Equipment_management", comment: ""), image: "mine_ic_bracelet"),
            XCContactCellModel(title: NSLocalizedString("My_QR_code", comment: ""), image: "mine_ic_qr"),
            XCContactCellModel(title: NSLocalizedString("about_us", comment: ""), image: "mine_ic_smiling"),
            XCContactCellModel(title: NSLocalizedString("Setting", comment: ""), image: "mine-gear"),
            XCContactCellModel(title: NSLocalizedString("log_out", comment: ""), image: "mine-gear")
        ]
    }
    
    // MARK: 设置
    class func getSettingVCData() -> [[XCSettingCellModel]] {
        return [
            [XCSettingCellModel(icon: nil, title: "帐号与安全", subTitle: nil, tipImg: nil, tipTitle: nil, type: .left)],
            [
                XCSettingCellModel(icon: nil, title: "新消息通知", subTitle: nil, tipImg: nil, tipTitle: nil, type: .left),
                XCSettingCellModel(icon: nil, title: "隐私", subTitle: nil, tipImg: nil, tipTitle: nil, type: .left),
                XCSettingCellModel(icon: nil, title: "通用", subTitle: nil, tipImg: nil, tipTitle: nil, type: .left)
            ],
            [
                XCSettingCellModel(icon: nil, title: "帮助与反馈", subTitle: nil, tipImg: nil, tipTitle: nil, type: .left)
            ],
            [XCSettingCellModel(icon: nil, title: "退出登录", subTitle: nil, tipImg: nil, tipTitle: nil, type: .middle)]
        ]
    }
}
