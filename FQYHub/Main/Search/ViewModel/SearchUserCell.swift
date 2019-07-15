//
//  SearchUserCell.swift
//  FQYHub
//
//  Created by ysq on 2019/7/15.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import UIKit

class SearchUserCell: UITableViewCell, BaseCellCommonFunc {
    
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
        
    }
    
    func setupConstraints() {
        
    }
    
    func bind(with cellModel: UserSearchCellViewModel) {
        
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
