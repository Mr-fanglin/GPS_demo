//
//  XCChatEmotionHelper.swift
//  
//
//  Created by FangLin on 2017/1/1.
//  Copyright © 2017年 FangLin. All rights reserved.
//


import UIKit

class XCChatEmotionHelper: NSObject {
    
    // MARK:- 获取表情模型数组
    class func getAllEmotions() -> [XCChatEmotion] {
        var emotions: [XCChatEmotion] = [XCChatEmotion]()
        let plistPath = Bundle.main.path(forResource: "Expression", ofType: "plist")
        let array = NSArray(contentsOfFile: plistPath!) as! [[String : String]]
        
        var index = 0
        for dict in array {
            emotions.append(XCChatEmotion(dict: dict))
            index += 1
            if index == 23 {
                // 添加删除表情
                emotions.append(XCChatEmotion(isRemove: true))
                index = 0
            }
        }
        
        // 添加空白表情
        emotions = self.addEmptyEmotion(emotiions: emotions)
        
        return emotions
    }
    
    // 添加空白表情
    fileprivate class func addEmptyEmotion(emotiions: [XCChatEmotion]) -> [XCChatEmotion] {
        var emos = emotiions
        let count = emos.count % 24
        if count == 0 {
            return emos
        }
        for _ in count..<23 {
            emos.append(XCChatEmotion(isEmpty: true))
        }
        emos.append(XCChatEmotion(isRemove: true))
        return emos
    }
    
    class func getImagePath(emotionName: String?) -> String? {
        if emotionName == nil {
            return nil
        }
        return Bundle.main.bundlePath + "/Expression.bundle/" + emotionName! + ".png"
    }
}
