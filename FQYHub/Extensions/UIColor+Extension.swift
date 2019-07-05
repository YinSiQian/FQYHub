//
//  UIColor+Extension.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/6/27.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    public convenience init(hex6: UInt32, alpha: CGFloat = 1) {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((hex6 & 0x00FF00) >>  8) / divisor
        let blue    = CGFloat( hex6 & 0x0000FF       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static func color(withHexString color: String?, alpha: CGFloat = 1) -> UIColor {
        //删除字符串中的空格
        guard var cString = color else {
            return UIColor.clear
        }
        cString = cString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        // String should be 6 or 8 characters
        if (cString.count ) < 6 {
            return UIColor.clear
        }
        // strip 0X if it appears
        //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
        if cString.hasPrefix("0x") {
            cString = (cString as NSString).substring(from: 2)
        }
        //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
        if cString.hasPrefix("#") {
            cString = (cString as NSString).substring(from: 1)
        }
        if cString.count != 6 {
            return UIColor.clear
        }
        
        // Separate into r, g, b substrings
        var range: NSRange = NSRange()
        range.location = 0
        range.length = 2
        //r
        let rString = (cString as NSString).substring(with: range)
        //g
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        //b
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        // Scan values
        var r: UInt32 = 0
        var g: UInt32 = 0
        var b: UInt32 = 0
        (Scanner(string: rString)).scanHexInt32(&r)
        (Scanner(string: gString)).scanHexInt32(&g)
        (Scanner(string: bString)).scanHexInt32(&b)
        return UIColor(red: CGFloat((Float(r) / 255.0)), green: CGFloat((Float(g) / 255.0)), blue: CGFloat((Float(b) / 255.0)), alpha: alpha)
    }
    
    public convenience init?(hex: String, alpha: CGFloat = 1) {
        let r, g, b, a: CGFloat
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
    
    
}
