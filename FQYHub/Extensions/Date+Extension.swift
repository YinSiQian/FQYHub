//
//  Date+Extension.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/7/10.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import Foundation
import UIKit

let dateFormatter = DateFormatter(withFormat: "yyyy-MM-dd", locale: "")

extension Date {
    
    var stringValue: String {
        return dateFormatter.string(from: self)
    }
    
}
