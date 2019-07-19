//
//  UserInfoHeaderView.swift
//  FQYHub
//
//  Created by ysq on 2019/7/9.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import UIKit

class UserInfoHeaderView: UIView {

    var backImage: UIImageView!
    
    var avatar: UIImageView!
    
    var name: UILabel!
    
    var effectView: UIVisualEffectView!
    
    var repos: UIButton!
    
    var followers: UIButton!
    
    var following: UIButton!
    
    var email: UILabel!
    
    var blog: UILabel!
    
    var location: UILabel!
    
    var company: UILabel!
    
    var user: User? {
        didSet {
            backImage.kf.setImage(with: user?.avatarUrl?.url, placeholder: Configs.DefaultSetting.placeholderImage)
            avatar.kf.setImage(with: user?.avatarUrl?.url, placeholder: Configs.DefaultSetting.placeholderImage)
            name.text = user?.login

            
            repos.setTitle("repos \n \(user?.repositoriesCount ?? 0)", for: .normal)
            followers.setTitle("followers \n \(user?.followers ?? 0)", for: .normal)
            following.setTitle("following \n \(user?.following ?? 0)", for: .normal)
            
            email.text = "Email: \(user?.email ?? "---")"
            blog.text = "Blog: \(user?.blog ?? "---")"
            location.text = "Location: \(user?.location ?? "---")"
            company.text = "Company: \(user?.company ?? "---")"
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
        
        avatar = UIImageView()
        avatar.layer.cornerRadius = 25
        avatar.layer.masksToBounds = true
        avatar.layer.borderColor = LightTheme().background.cgColor
        avatar.layer.borderWidth = 1
        addSubview(avatar)
        
        name = UILabel()
        name.textColor = LightTheme().text
        name.font = .systemFont(ofSize: 14)
        addSubview(name)
        
        repos = UIButton()
        repos.setTitleColor(.white, for: .normal)
        repos.titleLabel?.font = .systemFont(ofSize: 14)
        repos.backgroundColor = LightTheme().primary
        repos.titleLabel?.textAlignment = .center
        repos.layer.cornerRadius = Configs.BaseDimensions.cornerRadius
        repos.layer.masksToBounds = true
        repos.titleLabel?.numberOfLines = 2
        addSubview(repos)
        
        followers = UIButton()
        followers.setTitleColor(.white, for: .normal)
        followers.titleLabel?.font = .systemFont(ofSize: 14)
        followers.backgroundColor = LightTheme().primary
        followers.titleLabel?.textAlignment = .center
        followers.layer.cornerRadius = Configs.BaseDimensions.cornerRadius
        followers.layer.masksToBounds = true
        followers.titleLabel?.numberOfLines = 2
        addSubview(followers)
        
        following = UIButton()
        following.setTitleColor(.white, for: .normal)
        following.titleLabel?.font = .systemFont(ofSize: 14)
        following.backgroundColor = LightTheme().primary
        following.titleLabel?.textAlignment = .center
        following.layer.cornerRadius = Configs.BaseDimensions.cornerRadius
        following.layer.masksToBounds = true
        following.titleLabel?.numberOfLines = 2
        addSubview(following)
        
        email = UILabel()
        email.textColor = LightTheme().text
        email.font = .systemFont(ofSize: 14)
        email.textAlignment = .center
        addSubview(email)
        
        company = UILabel()
        company.textColor = LightTheme().text
        company.font = .systemFont(ofSize: 14)
        company.textAlignment = .center
        addSubview(company)
        
        blog = UILabel()
        blog.textColor = LightTheme().text
        blog.font = .systemFont(ofSize: 14)
        blog.textAlignment = .center
        addSubview(blog)
        
        location = UILabel()
        location.textColor = LightTheme().text
        location.font = .systemFont(ofSize: 14)
        location.textAlignment = .center
        addSubview(location)
        
        
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
            make.top.equalTo(self).offset(padding)
            make.height.width.equalTo(50)
        }
        
        name.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(avatar.snp.bottom).offset(10)
        }
        
        repos.snp.makeConstraints { (make) in
            make.width.equalTo(followers)
            make.left.equalTo(self).offset(padding)
            make.right.equalTo(followers.snp.left).offset(-10)
            make.top.equalTo(name.snp.bottom).offset(padding)
            make.height.equalTo(50)
        }
        
        followers.snp.makeConstraints { (make) in
            make.width.equalTo(repos)
            make.height.equalTo(repos)
            make.right.equalTo(following.snp.left).offset(-10)
            make.top.equalTo(name.snp.bottom).offset(padding)
        }
        
        following.snp.makeConstraints { (make) in
            make.width.equalTo(followers)
            make.height.equalTo(followers)
            make.right.equalTo(self).offset(-padding)
            make.top.equalTo(name.snp.bottom).offset(padding)
        }
        
        email.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.left.equalTo(self).offset(padding)
            make.right.equalTo(self).offset(-padding)
            make.top.equalTo(self.following.snp.bottom).offset(padding * 2)
        }
        
        blog.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.left.equalTo(self).offset(padding)
            make.right.equalTo(self).offset(-padding)
            make.top.equalTo(self.email.snp.bottom).offset(padding)
        }
        
        company.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.left.equalTo(self).offset(padding)
            make.right.equalTo(self).offset(-padding)
            make.top.equalTo(self.blog.snp.bottom).offset(padding)
        }
        
        location.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.left.equalTo(self).offset(padding)
            make.right.equalTo(self).offset(-padding)
            make.top.equalTo(self.company.snp.bottom).offset(padding)
        }
        
    
        
    }
    
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        avatar.snp.remakeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(80 + safeAreaInsets.top)
            make.height.width.equalTo(50)
        }
    }
}
