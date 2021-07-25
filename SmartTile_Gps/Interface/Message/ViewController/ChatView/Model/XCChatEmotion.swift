//
//  XCChatEmotion.swift
//  
//
//  Created by FangLin on 2017/1/1.
//  Copyright © 2017年 FangLin. All rights reserved.
//

import UIKit

class XCChatEmotion: NSObject {
    // MARK:- 定义属性
    @objc var image: String? {   // 表情对应的图片名称
        didSet {
            guard let bundlePath = Bundle.main.path(forResource: "Expression", ofType: "bundle") else {
                return
            }
            guard let imageName = image else {
                return
            }
            imgPath = String.init(format: "%@/%@.png", bundlePath,imageName)
            
        }
    }
    @objc var text: String?     // 表情对应的文字
    
    // MARK:- 数据处理
    var imgPath: String?
    var isRemove: Bool = false
    var isEmpty: Bool = false
    
    override init() {
        super.init()
    }
    
    convenience init(dict: [String : String]) {
        self.init()
        setValuesForKeys(dict)
    }
    
    init(isRemove: Bool) {
        self.isRemove = (isRemove)
    }
    init(isEmpty: Bool) {
        self.isEmpty = (isEmpty)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
