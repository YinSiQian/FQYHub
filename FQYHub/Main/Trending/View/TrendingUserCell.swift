//
//  TrendingUserCell.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/7/5.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import Foundation
import UIKit

class TrendingUserCell: UITableViewCell, BaseCellCommonFunc {
    
    private var avatar: UIImageView!
    
    private var name: UILabel!
    
    private var content: UILabel!
    
    private var separatorView: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews() {
        avatar = UIImageView()
        avatar.layer.cornerRadius = 25
        avatar.layer.masksToBounds = true
        contentView.addSubview(avatar)
        
        content = UILabel()
        content.textColor = LightTheme().textGray
        content.font = .systemFont(ofSize: 14)
        content.numberOfLines = 1
        contentView.addSubview(content)
        
        name = UILabel()
        name.textColor = LightTheme().text
        name.font = .systemFont(ofSize: 16)
        contentView.addSubview(name)
        
        separatorView = UIView()
        separatorView.backgroundColor = LightTheme().background
        contentView.addSubview(separatorView)
    }
    
    func setupConstraints() {
        
        let padding = Configs.BaseDimensions.inset
        let space = Configs.BaseDimensions.space
        
        
        avatar.snp.makeConstraints { (make) in
            make.width.height.equalTo(50)
            make.left.top.equalTo(self.contentView).offset(padding)
            make.bottom.equalTo(separatorView.snp.top).offset(-space)
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
        
        separatorView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(self.contentView)
            make.height.equalTo(12)
        }
    }
    
    public func bind(viewModel: TrendingUserCellViewModel) {
        
        viewModel.name.drive(name.rx.text).disposed(by: disposeBag)
        viewModel.content.drive(content.rx.text).disposed(by: disposeBag)
        viewModel.avatarUlr.drive(onNext: { [weak self] (url) in
            self?.avatar.kf.setImage(with: url, placeholder: Configs.DefaultSetting.placeholderImage)
            
        }).disposed(by: disposeBag)
        
    }
    
    
    
    
    
}
