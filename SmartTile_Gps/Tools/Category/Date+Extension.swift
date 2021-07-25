//
//  Date+Extension.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/10/15.
//  Copyright © 2020 fanglin. All rights reserved.
//

import Foundation

extension Date {
    static func currentTime() -> String {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return timeFormatter.string(from: date)
    }
}
