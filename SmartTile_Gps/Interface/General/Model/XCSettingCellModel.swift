//
//  XCSettingCellModel.swift
//  XinChat
//
//  Created by FangLin on 2019/10/16.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit

enum XCSettingCellType {
    case `default`
    case `check`
    case `switch`
    case `middle`
    case `avatar`
    case `left`
}

class XCSettingCellModel: NSObject {
    // 图标
    var icon: String?
    // 标题
    var title: String?
    // 副标题
    var subTitle: String?
    // 提示图
    var tipImg: String?
    // 提示语
    var tipTitle: String?
    // 类型
    var type: XCSettingCellType!
    
    override init() {
        super.init()
    }
    
    init(icon: String?, title: String?, subTitle:String? = nil, tipImg: String? = nil, tipTitle: String? = nil, type: XCSettingCellType = .default) {
        self.icon = icon
        self.title = title
        self.subTitle = subTitle
        self.tipImg = tipImg
        self.tipTitle = tipTitle
        self.type = type
    }
}
