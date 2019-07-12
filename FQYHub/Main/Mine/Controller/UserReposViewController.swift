//
//  UserReposViewController.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/7/11.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import UIKit
import MJRefresh

class UserReposViewController: BaseViewController {
    
    var username: String = ""

    lazy var tableView: UITableView = {
        let tb = UITableView(frame: self.view.bounds, style: .plain)
        tb.separatorStyle = .none
        tb.backgroundColor = LightTheme().background
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        let viewModel = UserReposViewModel(input: UserReposViewModel.Input(username: username, footerRefresh: self.tableView.mj_footer.rx.refreshing.asObservable(), selection: self.tableView.rx.modelSelected(TrendingRepositoryCellViewModel.self).asDriver()))
        
        
        viewModel.repos.bind(to: self.tableView.rx.items) {
            (tableView, row, element) in
            let cell = TrendingRepositoriesCell.cell(with: tableView)
            cell.bind(ViewModel: element)
            return cell
        }.disposed(by: disposeBag)
        
        viewModel.footerEndRefresh.bind(to: self.tableView.mj_footer.rx.endRefreshing).disposed(by: disposeBag)
        
        viewModel.noMoreData.bind(to: self.tableView.mj_footer.rx.endRefreshingWithNoMoreData).disposed(by: disposeBag)
        
        viewModel.selection.drive(onNext: { (url) in
            
            let web = WebViewController()
            web.url = url
            self.navigationController?.pushViewController(web, animated: true)

        }).disposed(by: disposeBag)
        
    }

}
