//
//  XCFileManager.swift
//  
//
//  Created by FangLin on 2017/1/14.
//  Copyright © 2017年 FangLin. All rights reserved.
//


import UIKit

class XCFileManager: NSObject {
    // MARK:- 判断文件(夹)是否存在
    class func isExists(at path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
}
