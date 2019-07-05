//
//  BaseCell.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/7/4.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import UIKit

class BaseCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static public func cell(with tableView: UITableView) -> BaseCell {
        let reuseId = NSStringFromClass(self)
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseId)
        if cell == nil {
            cell = BaseCell(style: .default, reuseIdentifier: reuseId)
        }
        return cell as! BaseCell
    }
    
    public func setupSubviews() {
        
    }
    
    public func setupConstraints() {
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
