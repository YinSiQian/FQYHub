//
//  RepositoryInfoCell.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/7/9.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import UIKit
import SnapKit

class RepositoryInfoCell: UITableViewCell, BaseCellCommonFunc {

    
    var title: UILabel!
    
    var content: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews() {
        
        title = UILabel()
        title.textColor = LightTheme().text
        title.font = .systemFont(ofSize: 14)
        contentView.addSubview(title)
        
        content = UILabel()
        content.textColor = LightTheme().text
        content.font = .systemFont(ofSize: 14)
        contentView.addSubview(content)
        
    }
    
    func setupConstraints() {
        
        title.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(15)
        }
        
        content.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.right.equalTo(self.contentView).offset(-15)
        }
        
    }
    
}
