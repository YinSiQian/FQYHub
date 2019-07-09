//
//  UserInfoViewController.swift
//  FQYHub
//
//  Created by ysq on 2019/7/9.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class UserInfoViewController: BaseViewController {

    var username: String = ""
    
    var user: User?
    
    private var noticeView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    
    private func bindViewModel() {
        
        self.view.show(with: "loading...")
        
        singleProvider.user(owner: username).asObservable().subscribe(onNext: { (user) in
            print(user)
            self.user = user
            self.setupSubviews()
        }, onError: { (error) in
            self.view.hideHUD()
            self.view.showFail(with: error.localizedDescription)
        }, onCompleted: {
            self.view.hideHUD()
        }).disposed(by: disposeBag)
        
    }
    
    private func setupSubviews() {
        
        let headerView = UserInfoHeaderView(frame: self.view.bounds)
        headerView.user = self.user
        view.addSubview(headerView)
        
        noticeView = UILabel()
        noticeView.text = "See more infomation about user >"
        noticeView.textAlignment = .center
        noticeView.font = .systemFont(ofSize: 14)
        noticeView.textColor = .white
        noticeView.backgroundColor = LightTheme().primary
        noticeView.isUserInteractionEnabled = true
        self.view.addSubview(noticeView)
        
        noticeView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.height.equalTo(40)
            make.top.equalTo(self.view.safeAreaInsets.top)
        }
        
        let tag = UITapGestureRecognizer(target: self, action: #selector(self.seeMoreInfo))
        noticeView.addGestureRecognizer(tag)
        
        
    }
    
    @objc private func seeMoreInfo() {
        let web = WebViewController()
        web.url = user?.htmlUrl
        navigationController?.pushViewController(web, animated: true)
    }
   

}
