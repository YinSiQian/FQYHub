//
//  ForksViewController.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/7/19.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import UIKit
import MJRefresh

class ForksViewController: BaseViewController {

    var fullname: String = ""
    
    lazy var tableView: UITableView = {
        let tb = UITableView(frame: self.view.bounds, style: .plain)
        tb.separatorStyle = .none
        tb.backgroundColor = LightTheme().background
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Fork List"
        setupSubviews()
        bindViewModel()
        self.tableView.mj_footer.beginRefreshing()


    }
    
    private func setupSubviews() {
        self.tableView.mj_footer = MJRefreshAutoNormalFooter()
        self.view.addSubview(tableView)
        
    }
    
    private func bindViewModel() {
        
        let input = ForksViewModel.Input(fullname: fullname,
                                            footerAction: self.tableView.mj_footer.rx.refreshing.asObservable(), selection: self.tableView.rx.modelSelected(TrendingRepositoryCellViewModel.self).asDriver())
        let output = ForksViewModel().transform(input: input)
        
        
        output.userSelection.drive(onNext: { (name) in
            
            let detail = RepositoryDetailController()
            detail.fullName = name
            self.navigationController?.pushViewController(detail, animated: true)
            
        }).disposed(by: disposeBag)
        
        output.starsElements.bind(to: self.tableView.rx.items) {
            (tableView, row, element) in
            let cell = TrendingRepositoriesCell.cell(with: tableView)
            cell.bind(ViewModel: element)
            return cell
        }.disposed(by: disposeBag)
        
        output.endRefresh.bind(to: self.tableView.mj_footer.rx.endRefreshing).disposed(by: disposeBag)
        
        output.noMoreData.bind(to: self.tableView.mj_footer.rx.endRefreshingWithNoMoreData).disposed(by: disposeBag)
        
    }



}
