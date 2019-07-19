//
//  RepositoryHeaderView.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/7/9.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class RepositoryHeaderView: UIView {
    
    var backImage: UIImageView!
    
    var avatar: UIButton!
    
    var info: UILabel!
    
    var watchers: UIButton!
    
    var stars: UIButton!
    
    var forks: UIButton!
    
    var effectView: UIVisualEffectView!
    
    var model: Repository? {
        didSet {
            backImage.kf.setImage(with: model?.owner?.avatarUrl?.url, placeholder: Configs.DefaultSetting.placeholderImage)
            avatar.kf.setBackgroundImage(with: model?.owner?.avatarUrl?.url, for: .normal)
            info.text = model?.descriptionField
            watchers.setTitle("watchers \n \(model?.watchers ?? 0)", for: .normal)
            stars.setTitle("stars \n \(model?.stargazersCount ?? 0)", for: .normal)
            forks.setTitle("forks \n \(model?.forks ?? 0)", for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        
        backImage = UIImageView()
        addSubview(backImage)
        
        effectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        addSubview(effectView)
        
        avatar = UIButton()
        avatar.setBackgroundImage(Configs.DefaultSetting.placeholderImage, for: .normal)
        avatar.layer.cornerRadius = 25
        avatar.layer.masksToBounds = true
        avatar.layer.borderColor = LightTheme().background.cgColor
        avatar.layer.borderWidth = 1
        addSubview(avatar)
        
        info = UILabel()
        info.textColor = LightTheme().text
        info.font = .systemFont(ofSize: 14)
        info.numberOfLines = 0
        addSubview(info)
        
        stars = UIButton()
        stars.setTitleColor(.white, for: .normal)
        stars.titleLabel?.font = .systemFont(ofSize: 14)
        stars.backgroundColor = LightTheme().primary
        stars.titleLabel?.textAlignment = .center
        stars.layer.cornerRadius = Configs.BaseDimensions.cornerRadius
        stars.layer.masksToBounds = true
        stars.titleLabel?.numberOfLines = 2
        addSubview(stars)
        
        watchers = UIButton()
        watchers.setTitleColor(.white, for: .normal)
        watchers.titleLabel?.font = .systemFont(ofSize: 14)
        watchers.backgroundColor = LightTheme().primary
        watchers.titleLabel?.textAlignment = .center
        watchers.layer.cornerRadius = Configs.BaseDimensions.cornerRadius
        watchers.layer.masksToBounds = true
        watchers.titleLabel?.numberOfLines = 2
        addSubview(watchers)
        
        forks = UIButton()
        forks.setTitleColor(.white, for: .normal)
        forks.titleLabel?.font = .systemFont(ofSize: 14)
        forks.backgroundColor = LightTheme().primary
        forks.titleLabel?.textAlignment = .center
        forks.layer.cornerRadius = Configs.BaseDimensions.cornerRadius
        forks.layer.masksToBounds = true
        forks.titleLabel?.numberOfLines = 2
        addSubview(forks)
        
    }
    
    private func setupConstraints() {
        
        let padding = Configs.BaseDimensions.inset
        
        backImage.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        effectView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        avatar.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(padding * 2)
            make.height.width.equalTo(50)
        }
        
        info.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(padding)
            make.top.equalTo(avatar.snp.bottom).offset(10)
            make.right.equalTo(self).offset(-padding)
        }
        
        stars.snp.makeConstraints { (make) in
            make.width.equalTo(watchers)
            make.left.equalTo(self).offset(padding)
            make.right.equalTo(watchers.snp.left).offset(-10)
            make.top.equalTo(info.snp.bottom).offset(padding)
            make.height.equalTo(50)
        }
        
        watchers.snp.makeConstraints { (make) in
            make.width.equalTo(stars)
            make.height.equalTo(stars)
            make.right.equalTo(forks.snp.left).offset(-10)
            make.top.equalTo(info.snp.bottom).offset(padding)
        }
        
        forks.snp.makeConstraints { (make) in
            make.width.equalTo(watchers)
            make.height.equalTo(stars)
            make.right.equalTo(self).offset(-padding)
            make.top.equalTo(info.snp.bottom).offset(padding)
        }
        
    }
    
    
    
}
