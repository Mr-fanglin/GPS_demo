//
//  XCContactCellModel.swift
//  
//
//  Created by FangLin on 2019/12/28.
//  Copyright © 2019年 FangLin. All rights reserved.
//

import UIKit
import NIMSDK

class XCContactCellModel: NSObject {
    // 标题
    var title: String?
    // 拼音
    var pinyin: String?
    // 图标
    var image: String?
    // userId
    var userId: String?
    
    
    override init() {
        super.init()
    }
    
    init(title: String?, image: String?) {
        self.title = title
        self.image = image
        self.pinyin = title?.pinyin()
    }
    
    init(user: NIMUser?) {
        let userInfo = user?.userInfo
        self.title = user?.alias ?? userInfo?.nickName ?? user?.userId
        self.image = userInfo?.avatarUrl
        self.pinyin = title?.pinyin()
        self.userId = user?.userId
    }
    
    class func getrecentSessionModel(_ user:XCContactCellModel)->XCRecentSessionModel {
        let model = XCRecentSessionModel()
        model.title = user.title
        model.userId = user.userId
        model.avatarPath = user.image
        return model
    }
}
