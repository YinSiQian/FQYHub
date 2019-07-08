//
//  RepositoryDetailController.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/7/5.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RepositoryDetailController: BaseViewController {

    var fullName: String = "" {
        didSet {
            title = fullName
        }
    }
    
    private var noticeView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        bindViewModel()
    }
    
    private func setupSubviews() {
        
        noticeView = UILabel(frame: CGRect(x: 0, y: 88, width: kScreen_width, height: 40))
        noticeView.text = "See more infomation about this repository >"
        noticeView.textAlignment = .center
        noticeView.font = .systemFont(ofSize: 14)
        noticeView.textColor = LightTheme().text
        noticeView.backgroundColor = LightTheme().primary
        noticeView.isUserInteractionEnabled = true
        self.view.addSubview(noticeView)
        
        let tag = UITapGestureRecognizer(target: self, action: #selector(self.seeMoreInfo))
        
        noticeView.addGestureRecognizer(tag)
        
    }
    
    private func bindViewModel() {
        
        let viewModel = RepositoryDetailViewModel(with: fullName)
        
        viewModel.repo.subscribe(onNext: { (repository) in
            print(repository)
        }).disposed(by: disposeBag)
    }
    
    @objc private func seeMoreInfo() {
        let web = WebViewController()
        web.url = "https://github.com/ddbourgin/numpy-ml"
        navigationController?.pushViewController(web, animated: true)
    }

}
