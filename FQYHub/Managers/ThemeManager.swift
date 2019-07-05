//
//  ThemeManager.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/7/4.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import Foundation
import UIKit

protocol Theme {
    
    var primary: UIColor { get }
    var text: UIColor { get }
    var textGray: UIColor { get }
    var textLightGray: UIColor { get }
    var textRed: UIColor { get }
    var background: UIColor { get }
    var separator: UIColor { get }
    var mask: UIColor { get }
}

struct LightTheme: Theme {
    
    var primary: UIColor = UIColor(hex6: 0x1890ff)
    
    var text: UIColor = UIColor(hex6: 0x282828)
    
    var textRed: UIColor = UIColor(hex6: 0xFF6A3F)
    
    var textLightGray: UIColor = UIColor(hex6: 0xa9a9a9)
    
    var textGray: UIColor = UIColor(hex6: 0x737373)
    
    var background: UIColor = UIColor(hex6: 0xf7f7f7)
    
    var separator: UIColor = UIColor(hex6: 0xe6e6e6)
    
    var mask: UIColor = UIColor(hex6: 0x282828, alpha: 0.8)
}
