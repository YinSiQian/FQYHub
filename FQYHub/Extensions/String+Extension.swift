//
//  String+Extension.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/6/27.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    var url: URL? {
        return URL(string: self)
    }

    public func calculate(font: UIFont, size: CGSize) -> CGSize {
        let size = (self as NSString).boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil).size
        return size
    }
    
}
