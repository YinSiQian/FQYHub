//
//  BaseCellProtocol.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/7/5.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import Foundation
import UIKit

protocol BaseCellCommonFunc {
    
    static func cell(with tableView: UITableView) -> Self
    
    func setupSubViews()
    
    func setupConstraints()
    
}

extension BaseCellCommonFunc where Self: UITableViewCell {
    
    static func cell(with tableView: UITableView) -> Self {
        let reuseId = NSStringFromClass(Self.self)
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseId)
        if cell == nil {
            cell = Self.init(style: .default, reuseIdentifier: reuseId)
        }
        return cell as! Self
    }
    
}
