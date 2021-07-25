//
//  XCContactHepler.swift
//  
//
//  Created by FangLin on 2019/12/28.
//  Copyright © 2019年 FangLin. All rights reserved.
//

import UIKit

class XCContactHepler: NSObject {
    // MARK:- 将联系人进行排序和分组操作
    class func getFriendListData(by array: [XCContactCellModel]) -> [[XCContactCellModel]] {
        // 排序 (升序)
        let serializedArr = array.sorted { (obj1, obj2) -> Bool in
            let strA = obj1.pinyin ?? ""
            let strB = obj2.pinyin ?? ""
            
            var i = 0
            while i < strA.count && i < strB.count {
                let a = strA.index(strA.startIndex, offsetBy: i)
                let b = strB.index(strB.startIndex, offsetBy: i)
                if a < b {
                    return true
                } else if a > b {
                    return false
                }
                i += 1
            }
            if strA.count < strB.count {
                return true
            } else if strA.count > strB.count {
                return false
            }
            
            return false
        }
        
        // 降序
        // serializedArr = serializedArr.reversed()
        
        // 分组
        var lastC = "1"
        var ans = [[XCContactCellModel]]()
        var data: [XCContactCellModel]?
        var other = [XCContactCellModel]()
        for user in serializedArr {
            let pinyin = user.pinyin ?? ""
            let c = pinyin.first?.description ?? ""
            if !c.isAlpha() {
                other.append(user)
            } else if c != lastC {
                lastC = c
                if (data != nil) && data!.count > 0 {
                    ans.append(data!)
                }
                data = [XCContactCellModel]()
                data?.append(user)
            } else {
                data!.append(user)
            }
        }
        if (data != nil) && data!.count > 0 {
            ans.append(data!)
        }
        if other.count > 0 {
            ans.append(other)
        }
        return ans
    }
    
    // 获取索引
    class func getFriendListSection(by array: [[XCContactCellModel]]) -> [String] {
        var section = [String]()
        section.append(UITableView.indexSearch) // 添加放大镜
        for item in array {
            let user = item.first
            var c = user?.pinyin?.first?.description ?? ""
            if !c.isAlpha() {
                c = "#"
            }
            section.append(c.uppercased())
        }
        return section
    }
}
