//
//  TrendingRepositoriesCell.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/7/4.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class TrendingRepositoriesCell: UITableViewCell, BaseCellCommonFunc {
    

    
    private var avatar: UIImageView!
    
    private var name: UILabel!
    
    private var content: UILabel!
    
    private var starTotoalNum: UILabel!
    
    private var starPeriodNum: UILabel!
    
    private var language: UILabel!
    
    private var languageColor: UIView!
    
    private var separatorView: UIView!
    
    private var total_star: UIImageView!
    
    private var period_star: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
        setupConstraints()
        selectionStyle = .none
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
        content.numberOfLines = 4
        contentView.addSubview(content)
        
        name = UILabel()
        name.textColor = LightTheme().text
        name.font = .systemFont(ofSize: 16)
        contentView.addSubview(name)
        
        starTotoalNum = UILabel()
        starTotoalNum.textColor = LightTheme().text
        starTotoalNum.font = .systemFont(ofSize: 12)
        contentView.addSubview(starTotoalNum)
        
        starPeriodNum = UILabel()
        starPeriodNum.textColor = LightTheme().textRed
        starPeriodNum.font = .systemFont(ofSize: 12)
        contentView.addSubview(starPeriodNum)
        
        language = UILabel()
        language.textColor = LightTheme().text
        language.font = .systemFont(ofSize: 12)
        contentView.addSubview(language)
        
        languageColor = UIView()
        languageColor.layer.cornerRadius = 4
        languageColor.layer.masksToBounds = true
        contentView.addSubview(languageColor)
        
        separatorView = UIView()
        separatorView.backgroundColor = LightTheme().background
        contentView.addSubview(separatorView)
        
        total_star = UIImageView()
        total_star.image = UIImage(named: "icon_trend_t_star")
        contentView.addSubview(total_star)
        
        period_star = UIImageView()
        period_star.image = UIImage(named: "icon_trend_p_star")
        contentView.addSubview(period_star)
        
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
        
        separatorView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(self.contentView)
            make.height.equalTo(12)
        }
        
        
        total_star.snp.makeConstraints { (make) in
            make.top.equalTo(self.content.snp.bottom).offset(space)
            make.left.equalTo(self.avatar.snp.right).offset(space)
            make.bottom.equalTo(self.separatorView.snp.top).offset(-padding)
        }
        
        starTotoalNum.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.total_star)
            make.left.equalTo(self.total_star.snp.right).offset(4)
        }
        
        period_star.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.total_star)
            make.left.equalTo(self.starTotoalNum.snp.right).offset(20)
        }
        
        starPeriodNum.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.total_star)
            make.left.equalTo(self.period_star.snp.right).offset(4)
        }
        
        languageColor.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.starTotoalNum)
            make.width.height.equalTo(8)
            make.left.equalTo(self.starPeriodNum.snp.right).offset(20)
        }
        
        language.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.languageColor)
            make.left.equalTo(self.languageColor.snp.right).offset(4)
        }
    }
    
    
    
    public func bind(ViewModel: TrendingRepositoryCellViewModel) {
        
        ViewModel.name.drive(name.rx.text).disposed(by: disposeBag)
        ViewModel.content.drive(content.rx.text).disposed(by: disposeBag)
        ViewModel.language.drive(language.rx.text).disposed(by: disposeBag)
        ViewModel.stars.drive(starTotoalNum.rx.text).disposed(by: disposeBag)
        ViewModel.periodStars.drive(starPeriodNum.rx.text).disposed(by: disposeBag)
        ViewModel.languageColor.drive(languageColor.rx.backgroundColor).disposed(by: disposeBag)
        ViewModel.avatarUlr.drive(onNext: { [weak self] (url) in
            self?.avatar.kf.setImage(with: url, placeholder: Configs.DefaultSetting.placeholderImage)

        }).disposed(by: disposeBag)
        
        ViewModel.isTrending.drive(onNext: { [weak self] (isTrending) in
            
            if !isTrending {
                self?.period_star.image = nil
                self?.language.textColor = LightTheme().primary
            } else {
                self?.period_star.image = UIImage(named: "icon_trend_p_star")
                self?.language.textColor = LightTheme().text
            }
            
        }).disposed(by: disposeBag)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
