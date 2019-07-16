//
//  SearchViewController.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/7/5.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import MJRefresh
import RxDataSources

class SearchViewController: UIViewController {

    lazy var segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: [TrendingSearchTypeSegments.repositories.currentTitle, TrendingSearchTypeSegments.users.currentTitle])
        segment.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)], for: .normal)
        segment.selectedSegmentIndex = 0
        segment.tintColor = LightTheme().primary
        return segment
    }()
    
    lazy var tableView: UITableView = {
        let tb = UITableView(frame: self.view.bounds, style: .plain)
        tb.separatorStyle = .none
        tb.backgroundColor = LightTheme().background
        tb.keyboardDismissMode = .onDrag
        tb.contentInsetAdjustmentBehavior = .automatic
        tb.estimatedSectionFooterHeight = 0
        tb.estimatedSectionHeaderHeight = 0
        return tb
    }()
    
    lazy var searchBar: UISearchBar = {
        
        let bar = UISearchBar()
        bar.barTintColor = .white
        bar.layer.cornerRadius = 15
        bar.layer.masksToBounds = true
        bar.layer.borderColor = LightTheme().primary.cgColor
        bar.layer.borderWidth = 1
        bar.placeholder = "Search"
        
        return bar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        bindViewModel()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        let insets = view.safeAreaInsets
        searchBar.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(15)
            make.right.equalTo(self.view).offset(-15)
            make.height.equalTo(30)
            make.top.equalTo(self.view).offset(insets.top + 10)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.left.right.bottom.equalTo(self.view)
        }
    }
    
    private func setupSubviews() {
        self.tableView.mj_footer = MJRefreshAutoNormalFooter()
        self.view.addSubview(tableView)
        self.navigationItem.titleView = segmentControl
        self.view.addSubview(searchBar)
        
    }
    
    private func bindViewModel() {
        
        let searchType = segmentControl.rx.selectedSegmentIndex.asObservable().map { (index) -> TrendingSearchTypeSegments in
            return TrendingSearchTypeSegments(rawValue: index)!
        }
        let keyworkTrigger = searchBar.rx.text.orEmpty.asObservable()
        
        let output = SearchViewModel().transform(input: SearchViewModel.Input(keyworkTrigger: keyworkTrigger, segmentSelection: searchType, footerRefresh: self.tableView.mj_footer.rx.refreshing.asObservable(), userSelect: self.tableView.rx.modelSelected(SearchSelectionItem.self).asDriver()))
        
        let dataSource = RxTableViewSectionedReloadDataSource<SearchSelection>(configureCell:  { (data, tableView, indexPath, item) -> UITableViewCell in
            
            switch item {
            case .repo(let viewModel):
                let cell = TrendingRepositoriesCell.cell(with: tableView)
                cell.bind(ViewModel: viewModel)
                return cell
            case .user(let viewModel):
                let cell = SearchUserCell.cell(with: tableView)
                cell.bind(with: viewModel)
                return cell
            }
        })
        
        output.searchSelection.asObservable().bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)

        output.userSelected.drive(onNext: { (user) in
            
            let userInfo = UserInfoViewController()
            userInfo.username = user.login ?? ""
            self.navigationController?.pushViewController(userInfo, animated: true)
            
        }).disposed(by: disposeBag)
        
        output.repoSelected.drive(onNext: { (repo) in
            
            let repoDetail = RepositoryDetailController()
            repoDetail.fullName = repo.fullname ?? ""
            self.navigationController?.pushViewController(repoDetail, animated: true)
            
        }).disposed(by: disposeBag)
        
        output.footerEndRefresh.bind(to: self.tableView.mj_footer.rx.endRefreshing).disposed(by: disposeBag)
        
        output.noMoreData.bind(to: self.tableView.mj_footer.rx.endRefreshingWithNoMoreData).disposed(by: disposeBag)
        
    }
    

    

}
