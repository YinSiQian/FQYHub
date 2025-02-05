//
//  TrendingViewController.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/6/27.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit
import RxDataSources

class TrendingViewController: UIViewController {

    lazy var tableView: UITableView = {
        let tb = UITableView(frame: self.view.bounds, style: .plain)
        tb.separatorStyle = .none
        return tb
    }()
    
    lazy var segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: [TrendingSearchTypeSegments.repositories.currentTitle, TrendingSearchTypeSegments.users.currentTitle])
        segment.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)], for: .normal)
        segment.selectedSegmentIndex = 0
        segment.tintColor = LightTheme().primary
        
        return segment
    }()
    
    lazy var searchSegmentControl: SegmentControl = {
        let titles = [TrendingSegments.daily.currentTitle,
                      TrendingSegments.weekly.currentTitle,
                      TrendingSegments.monthly.currentTitle]
        let segment = SegmentControl(sectionTitles: titles)
        return segment!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        bindViewModel()
        TuiVC.appkey("2bbb72b36f01b", vc: self)
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        let insets = view.safeAreaInsets
        searchSegmentControl.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view).offset(insets.top)
            make.height.equalTo(Configs.BaseDimensions.segmentHeight)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchSegmentControl.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
    }
    
    private func setupSubviews() {
        view.addSubview(searchSegmentControl)
        view.addSubview(tableView)
        
        navigationItem.titleView = segmentControl
       
    }
    
    private func bindViewModel() {
        
        
        let trendingType = segmentControl.rx.selectedSegmentIndex.asObservable().map { (index) -> TrendingSearchTypeSegments in
            return TrendingSearchTypeSegments(rawValue: index)!
        }
        
        let segmentSelected = searchSegmentControl.segmentSelection.map { (index) -> TrendingSegments in
            return TrendingSegments(rawValue: index)!
        }
        
        let viewModel = TrendingViewModel(selection: segmentSelected,
                                          trendingType: trendingType,
                                          selectionItem: tableView.rx.modelSelected(TrendingSectionItem.self).asDriver())
        
        let dataSource = RxTableViewSectionedReloadDataSource<TrendingSection>(configureCell:  { (data, tableView, indexPath, item) -> UITableViewCell in
            
            switch item {
                case .trendingRepositoriesItem(let viewModel):
                    let cell = TrendingRepositoriesCell.cell(with: tableView)
                    cell.bind(ViewModel: viewModel)
                    return cell
                case .trendingUserItem(let viewModel):
                    let cell = TrendingUserCell.cell(with: tableView)
                    cell.bind(viewModel: viewModel)
                    return cell
            }
        })
        
        viewModel.elements.asObservable().bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        
        viewModel.userSelected.drive(onNext: { (username) in
            
            print("user click \(username)" )
            let user = UserInfoViewController()
            user.title = username
            user.username = username
            self.navigationController?.pushViewController(user, animated: true)
            
        }).disposed(by: disposeBag)
        
        viewModel.repositorySelected.drive(onNext: { (fullName) in
            
            print("repository click \(fullName)" )
            
            let detail = RepositoryDetailController()
            detail.fullName = fullName
            self.navigationController?.pushViewController(detail, animated: true)
            
        }).disposed(by: disposeBag)
    }
    

}
