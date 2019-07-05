//
//  TrendingRepositoriesCell.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/7/4.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import UIKit
import SnapKit

class TrendingRepositoriesCell: BaseCell {

    
    private var avatar: UIImageView!
    
    private var name: UILabel!
    
    private var content: UILabel!
    
    private var starTotoalNum: UILabel!
    
    private var starPeriodNum: UILabel!
    
    private var language: UILabel!
    
    private var languageColor: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setupSubviews() {
        
        avatar = UIImageView()
        avatar.layer.cornerRadius = 30
        avatar.layer.masksToBounds = true
        contentView.addSubview(avatar)
        
        content = UILabel()
        content.textColor = LightTheme().textGray
        content.font = .systemFont(ofSize: 14)
        content.numberOfLines = 0
        contentView.addSubview(content)
        
        name = UILabel()
        name.textColor = LightTheme().text
        name.font = .systemFont(ofSize: 16)
        contentView.addSubview(name)
        
        starTotoalNum = UILabel()
        starTotoalNum.textColor = LightTheme().text
        starTotoalNum.font = .systemFont(ofSize: 14)
        contentView.addSubview(starTotoalNum)
        
        starPeriodNum = UILabel()
        starPeriodNum.textColor = LightTheme().textRed
        starPeriodNum.font = .systemFont(ofSize: 14)
        contentView.addSubview(starPeriodNum)
        
        language = UILabel()
        language.textColor = LightTheme().text
        language.font = .systemFont(ofSize: 14)
        contentView.addSubview(language)
        
        languageColor = UIView()
        languageColor.layer.cornerRadius = 5
        languageColor.layer.masksToBounds = true
        contentView.addSubview(languageColor)
        
    }
    
    override func setupConstraints() {
        
        let padding = Configs.BaseDimensions.inset
        let space = Configs.BaseDimensions.space
        
        avatar.snp.makeConstraints { (make) in
            make.width.height.equalTo(60)
            make.left.top.equalTo(self.contentView).offset(padding)
        }
        
        name.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(padding)
            make.left.equalTo(self.avatar.snp.right).offset(space)
            make.right.equalTo(self.contentView).offset(-padding)
        }
        
        content.snp.makeConstraints { (make) in
            make.top.equalTo(self.name.snp.bottom).offset(space)
            make.left.equalTo(self.avatar.snp.right).offset(space)
            make.right.equalTo(self.contentView).offset(-padding)
        }
        
        starTotoalNum.snp.makeConstraints { (make) in
            make.top.equalTo(self.content.snp.bottom).offset(space)
            make.left.equalTo(self.avatar.snp.right).offset(space)
            make.bottom.equalTo(self.contentView).offset(-padding)
        }
        
        starPeriodNum.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.starTotoalNum)
            make.left.equalTo(self.starTotoalNum.snp.right).offset(100)
        }
        
        languageColor.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.starTotoalNum)
            make.width.height.equalTo(10)
            make.left.equalTo(self.starPeriodNum.snp.right).offset(140)
        }
        
        language.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.languageColor)
            make.left.equalTo(self.languageColor.snp.right).offset(2)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
