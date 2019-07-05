//
//  TrendingViewController.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/6/27.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import UIKit
import RxSwift

class TrendingViewController: UIViewController {

    lazy var tableView: UITableView = {
        let tb = UITableView(frame: self.view.bounds, style: .plain)
        return tb
    }()
    
    lazy var segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: [TrendingSearchTypeSegments.repositories.currentTitle, TrendingSearchTypeSegments.users.currentTitle])
        segment.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)], for: .normal)
        segment.selectedSegmentIndex = 0
        segment.tintColor = LightTheme().primary
        
        return segment
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupSubviews() {
        view.addSubview(tableView)
        navigationItem.titleView = segmentControl
        let segmentSelected = segmentControl.rx.selectedSegmentIndex.asObservable().map { (index) -> TrendingSegments in
            return TrendingSegments(rawValue: index)!
        }
        
        let viewModel = TrendingViewModel(selection: segmentSelected)
        
        viewModel.trendingRepositoryResult.bind(to: tableView.rx.items) {
            (tableView, row, element) in
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            cell.textLabel?.text = element.author
            cell.detailTextLabel?.text = element.name
            return cell
        }.disposed(by: disposeBag)
    }
    

}
