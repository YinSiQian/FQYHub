//
//  MineCell.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/7/11.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import UIKit

class MineCell: UITableViewCell, BaseCellCommonFunc {
    
    var title: UILabel!
    
    private var icon: UIImageView!
    
    var des: UILabel!
    
    private var arrow: UIImageView!
    
    private var backView: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = LightTheme().background
        selectionStyle = .none
        setupSubViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews() {
        
        backView = UIView()
        backView.backgroundColor = .white
        backView.layer.cornerRadius = Configs.BaseDimensions.cornerRadius
        backView.layer.masksToBounds = true
        contentView.addSubview(backView)
        
        title = UILabel()
        title.textColor = LightTheme().primary
        title.font = .boldSystemFont(ofSize: 15)
        backView.addSubview(title)
        
        
//        icon = UIImageView()
//        backView.addSubview(icon)
        
        des = UILabel()
        des.textColor = LightTheme().text
        des.font = .systemFont(ofSize: 14)
        backView.addSubview(des)
        
        arrow = UIImageView()
        arrow.image = UIImage(named: "icon_arrow")
        backView.addSubview(arrow)
        
    }
    
    func setupConstraints() {
        
        backView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView).inset(UIEdgeInsets(top: 6, left: 15, bottom: 6, right: 15))
        }
        
        title.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.backView)
            make.left.equalTo(self.backView).offset(10)
        }
        
        des.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.backView)
            make.right.equalTo(self.backView.snp.right).offset(-30)
        }
        
        arrow.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.backView)
            make.right.equalTo(self.backView.snp.right).offset(-10)
        }
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
