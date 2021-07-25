//
//  XCChatMsgTimeHelper.swift
//  
//
//  Created by FangLin on 2019/1/8.
//  Copyright © 2019年 FangLin. All rights reserved.
//


import UIKit
import SwiftDate

class XCChatMsgTimeHelper: NSObject {
    
    static let shared: XCChatMsgTimeHelper = {
        let helper = XCChatMsgTimeHelper()
        return helper
    }()
    
    override init() {
        super.init()
//        // 设置时区
        let regionRome = Region.init(calendar: Calendars.chinese, zone: Zones.current, locale: Locales.current)
        SwiftDate.defaultRegion = regionRome
    }
}

// MARK:- 是否需要添加分钟模型
extension XCChatMsgTimeHelper {
    func needAddMinuteModel(preModel: XCChatMsgModel, curModel: XCChatMsgModel) -> Bool {
        guard let preTime = preModel.time  else {
            return false
        }
        guard let curTime = curModel.time else {
            return false
        }
        let preDate = Date(timeIntervalSince1970: preTime)
        let preInRome = DateInRegion(preDate)
        let curDate = Date(timeIntervalSince1970: curTime)
        let curInRome = DateInRegion(curDate)
        
        let yesr = curInRome.year - preInRome.year
        let month = curInRome.month - preInRome.month
        let day = curInRome.day - preInRome.day
        let hour = curInRome.hour - preInRome.hour
        let minute = curInRome.minute - preInRome.minute
        if yesr > 0 || month > 0 || day > 0 || hour > 0 {
            return true
        } else if minute >= 5 {
            return true
        } else {
            return false
        }
    }
}

// MARK:- 求时间字符串
extension XCChatMsgTimeHelper {
    func chatTimeString(with modelTime: TimeInterval?) -> String? {
        guard let time = modelTime else {
            return nil
        }
        // 消息时间
        let date = Date.init(timeIntervalSince1970: time)
        let dateInRome = DateInRegion.init(date, region: SwiftDate.defaultRegion)
        // 当前时间
        let now = DateInRegion()
        
        // 相差年份
        let year = now.year - dateInRome.year
        // 相差月数
        let month = now.month - dateInRome.month
        // 相差天数
        let day = now.day - dateInRome.day
        // 相差小时
        let hour = now.hour - dateInRome.hour
        // 相差分钟
        let minute = now.minute - dateInRome.minute
        // 相差秒数
        let second = now.second - dateInRome.second
        
        if year != 0 {
            return String(format: "%d年%d月%d日 %d:%02d", dateInRome.year, dateInRome.month, dateInRome.day, dateInRome.hour, dateInRome.minute)
        } else if year == 0 {
            if month > 0 || day > 7 {
                return String(format: "%d月%d日 %d:%02d", dateInRome.month, dateInRome.day, dateInRome.hour, dateInRome.minute)
            } else if day > 2 {
                return String(format: "%@ %d:%02d", dateInRome.weekdayName(.default), dateInRome.hour, dateInRome.minute)
            } else if day == 2 {
                return String(format: "前天 %d:%d", dateInRome.hour, dateInRome.minute)
            } else if dateInRome.isYesterday {
                return String(format: "昨天 %d:%d", dateInRome.hour, dateInRome.minute)
            } else if hour > 0 {
                return String(format: "%d:%02d",dateInRome.hour, dateInRome.minute)
            } else if minute > 0 {
                return String(format: "%02d分钟前",minute)
            } else if second > 3 {
                return String(format: "%d秒前",second)
            } else  {
                return String(format: "刚刚")
            }
        }
        return ""
    }
}
