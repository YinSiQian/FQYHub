//
//  FollowingListViewController.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/7/12.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import UIKit
import RxSwift
import MJRefresh
import RxCocoa

class FollowingListViewController: BaseViewController {

    var username: String = ""
    
    lazy var tableView: UITableView = {
        let tb = UITableView(frame: self.view.bounds, style: .plain)
        tb.separatorStyle = .none
        tb.backgroundColor = LightTheme().background
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Following"
        setupSubviews()
        bindViewModel()
        self.tableView.mj_footer.beginRefreshing()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    private func setupSubviews() {
        self.view.addSubview(tableView)
        self.tableView.mj_footer = MJRefreshAutoNormalFooter()
        
    }
    
    private func bindViewModel() {
        
        let output = FollowingViewModel().transform(input:
            FollowingViewModel.Input(username: username,
                                     footerRefresh: self.tableView.mj_footer.rx.refreshing.asObservable(), selection: self.tableView.rx.modelSelected(TrendingUserCellViewModel.self).asDriver()))
        
        output.users.bind(to: self.tableView.rx.items) {
            (tableView, row, element) in
            let cell = TrendingUserCell.cell(with: tableView)
            cell.bind(viewModel: element)
            return cell
        }.disposed(by: disposeBag)
        
        output.footerEndRefresh.bind(to: self.tableView.mj_footer.rx.endRefreshing).disposed(by: disposeBag)
        
        output.noMoreData.bind(to: self.tableView.mj_footer.rx.endRefreshingWithNoMoreData).disposed(by: disposeBag)
        
        output.userSelection.drive(onNext: { (name) in
            
            let userInfo = UserInfoViewController()
            userInfo.username = name
            self.navigationController?.pushViewController(userInfo, animated: true)
            
        }).disposed(by: disposeBag)
        
    }

    

}
