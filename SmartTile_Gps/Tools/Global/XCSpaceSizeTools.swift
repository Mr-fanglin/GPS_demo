//
//  XCSpaceSizeTools.swift
//  XinChat
//
//  Created by FangLin on 2019/11/5.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit

class XCSpaceSizeTools: NSObject {
    static let shared:XCSpaceSizeTools = XCSpaceSizeTools()
}

// MARK:- 获取空间大小对应的文字说明
extension XCSpaceSizeTools {
    func getSizeString(size: Int) -> String {
        let size:CGFloat      = CGFloat(size)
        let sizeUnit: CGFloat = 1024.0
        if size < sizeUnit { // B
            return String(format: "%lldB", size)
        } else if size < sizeUnit * sizeUnit {  // KB
            return String(format: "%.1fKB", size / sizeUnit)
        } else if size < sizeUnit * sizeUnit * sizeUnit {   // MB
            return String(format: "%.1fMB", size / (sizeUnit * sizeUnit))
        } else{ // GB
            return String(format: "%.1fG", size / (sizeUnit * sizeUnit * sizeUnit))
        }
    }
}
