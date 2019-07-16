//
//  SearchUserCell.swift
//  FQYHub
//
//  Created by ysq on 2019/7/15.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import UIKit
import RxSwift

class SearchUserCell: UITableViewCell, BaseCellCommonFunc {
    
    
    var avatar: UIImageView!
    
    var name: UILabel!
    
    var content: UILabel!
    
    var repos: UILabel!
    
    var stars: UILabel!
    
    var followers: UILabel!
    
    var separatorView: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
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
        
        stars = UILabel()
        stars.textColor = LightTheme().text
        stars.font = .systemFont(ofSize: 12)
        contentView.addSubview(stars)
        
        repos = UILabel()
        repos.textColor = LightTheme().text
        repos.font = .systemFont(ofSize: 12)
        contentView.addSubview(repos)
        
        followers = UILabel()
        followers.textColor = LightTheme().text
        followers.font = .systemFont(ofSize: 12)
        contentView.addSubview(followers)
        
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
        
        stars.snp.makeConstraints { (make) in
            make.top.equalTo(self.content.snp.bottom).offset(space)
            make.left.equalTo(self.avatar.snp.right).offset(space)
            make.bottom.equalTo(self.separatorView.snp.top).offset(-space)
        }
        
        followers.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.stars)
            make.left.equalTo(self.stars.snp.right).offset(space)
        }
        
        repos.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.stars)
            make.left.equalTo(self.followers.snp.right).offset(space)
        }
        
        
        separatorView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(self.contentView)
            make.height.equalTo(12)
        }
        
    }
    
    func bind(with cellModel: UserSearchCellViewModel) {
        cellModel.name.drive(name.rx.text).disposed(by: disposeBag)
        cellModel.des.drive(content.rx.text).disposed(by: disposeBag)
        cellModel.stars.drive(stars.rx.text).disposed(by: disposeBag)
        cellModel.followers.drive(followers.rx.text).disposed(by: disposeBag)
        cellModel.repos.drive(repos.rx.text).disposed(by: disposeBag)
        
        cellModel.avatar.drive(onNext: { (url) in
            self.avatar.kf.setImage(with: url.url, placeholder: Configs.DefaultSetting.placeholderImage)
        }).disposed(by: disposeBag)
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
