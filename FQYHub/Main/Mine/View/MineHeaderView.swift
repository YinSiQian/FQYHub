//
//  MineHeaderView.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/7/11.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import UIKit

class MineHeaderView: UIView {
    
    var backImage: UIImageView!
    
    var avatar: UIButton!
    
    var name: UILabel!
    
    var info: UILabel!
    
    var effectView: UIVisualEffectView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        
        backImage = UIImageView()
        addSubview(backImage)
        
        effectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        addSubview(effectView)
        
        avatar = UIButton()
        avatar.layer.cornerRadius = 25
        avatar.layer.masksToBounds = true
        avatar.layer.borderColor = LightTheme().background.cgColor
        avatar.layer.borderWidth = 1
        avatar.setBackgroundImage(#imageLiteral(resourceName: "github"), for: .normal)
        addSubview(avatar)
        
        name = UILabel()
        name.textColor = LightTheme().text
        name.font = .systemFont(ofSize: 14)
        name.numberOfLines = 2
        addSubview(name)
        
        info = UILabel()
        info.textColor = LightTheme().text
        info.font = .systemFont(ofSize: 14)
        info.numberOfLines = 0
        addSubview(info)
        
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
        
        name.snp.makeConstraints { (make) in
            make.top.equalTo(avatar.snp.bottom).offset(10)
            make.centerX.equalTo(avatar)
        }
        
        info.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(padding)
            make.top.equalTo(name.snp.bottom).offset(10)
            make.right.equalTo(self).offset(-padding)
        }
    }
    
    
    public func updateInfo() {
        
        if let user = User.currentUser() {
            
            backImage.kf.setImage(with:user.avatarUrl?.url, placeholder: Configs.DefaultSetting.placeholderImage)
            avatar.kf.setBackgroundImage(with: user.avatarUrl?.url, for: .normal)
            info.text = user.descriptionField

            if let loginName = user.login {
                name.text = "\(loginName)"
            }
        }
    }
}
