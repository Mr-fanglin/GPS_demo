//
//  StringEx.swift
//  Sheng
//
//  Created by FangLin on 2017/8/18.
//  Copyright © 2019 FangLin. All rights reserved.
//

import Foundation

extension String{
    /// 取子字符串
    ///
    /// - Parameters:
    ///   - startIndex: 开始位置索引
    ///   - endIndex: 结束位置索引
    /// - Returns: 从开始位置到结束位置的前一个位置上的字符串
    func substring(startIndex:Int, endIndex:Int) -> String {
        let start = self.index(self.startIndex, offsetBy: startIndex)  //索引从开始偏移startIndex个位置
        let end = self.index(self.startIndex, offsetBy: endIndex)  //索引从开始偏移endIndex个位置
        let range = start..<end
        return self.substring(with: range)
    }
    
    /// 获取指定行间距的字符串
    ///
    /// - Parameters:
    ///   - lineSpace: 行间距
    /// - Returns: 指定行间距的字符串
    func getLineSpaceAttributeString(lineSpace:CGFloat
        ) -> NSAttributedString{
        let attributedString = NSMutableAttributedString(string: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        let range = NSMakeRange(0, (self as NSString).length)
        attributedString .addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        return attributedString
    }
    
    /// 过滤非法字符
    ///
    /// - Returns: 过滤后的字符
    func filterInvaildChar() -> String {
        if self.count > 0 {
            let invaildCharArr:[Character] = ["\u{200f}","\u{0787}","\u{06af}","\u{0648}"]
            var hasInvaildChar = false
            for char in invaildCharArr{
                if self.index(of: char) != nil{
                    hasInvaildChar = true
                }
            }
            if hasInvaildChar == false{
                return self
            }
            if self == "\u{2666}\u{200f}\u{8a00}\u{535a}"{ //♦‏言博
                return "\u{8a00}\u{535a}\u{2666}"
            }
            if self == "\u{06af}\u{0648}\u{987e}\u{4e00}\u{724c}"{ //گو顾一牌
                return "\u{987e}\u{4e00}\u{724c}\u{06af}\u{0648}"
            }
            var resultStr = self
            for char in invaildCharArr{
                resultStr = resultStr.replacingOccurrences(of: String.init(char), with: "")
            }
            return resultStr
        }
        return self
    }
}

// MARK:- 登录专用
extension String {
    func MD5String() -> String {
        // CC_MD5 需要 #import <CommonCrypto/CommonDigest.h>
        let cStr = self.cString(using: String.Encoding.utf8);
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString();
        for i in 0 ..< 16{
            md5String.appendFormat("%02x", buffer[i])
        }
        free(buffer)
        return md5String as String
    }
    
    func tokenByPassword() -> String {
        return self.MD5String()
    }
    
}

// MARK:- 通讯录
extension String {
    // 判断是否为字母
    func isAlpha() -> Bool {
        if self == "" {
            return false
        }
        for chr in self {
            let chrStr = chr.description
            if (!(chrStr >= "a" && chrStr <= "z") && !(chrStr >= "A" && chrStr <= "Z") ) {
                Dprint("false")
                return false
            }
        }
//        Dprint("true")
        return true
    }
    
    // 拼音
    func pinyin() -> String {
        let str = NSMutableString(string: self)
        CFStringTransform(str as CFMutableString, nil, kCFStringTransformMandarinLatin, false)
        CFStringTransform(str as CFMutableString, nil, kCFStringTransformStripDiacritics, false)
        return str.replacingOccurrences(of: " ", with: "")
    }
}

extension String {
    // MARK:- 获取字符串的CGSize
    func getSize(with font: UIFont) -> CGSize {
        return getSize(width: UIScreen.main.bounds.width, font: font)
    }
    // MARK:- 获取字符串的CGSize(指定宽度)
    func getSize(width: CGFloat, font: UIFont) -> CGSize {
        let str = self as NSString
        
        let size = CGSize(width: width, height: CGFloat(FLT_MAX))
        return str.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil).size
    }
}

