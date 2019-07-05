//
//  ViewController.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/6/27.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import UIKit
import RxSwift
import Moya

class ViewController: UIViewController {

    var options: Int? = 8
    
    var noValueOptions: Int?
        
    lazy var tableView: UITableView = {
        let tb = UITableView(frame: self.view.bounds, style: .plain)
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let obserable = Observable<TrendingSegments>.of(.daily)
        let viewModel = TrendingViewModel(selection: obserable)

        view.addSubview(tableView)
    
        viewModel.trendingRepositoryResult.bind(to: tableView.rx.items) {
            (tableView, row, element) in
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            cell.textLabel?.text = element.name
            cell.detailTextLabel?.text = element.name
            return cell
        }.disposed(by: disposeBag)
        
        
        
        
        
        
        
        
        let provider = MoyaProvider<TrendingAPI>(plugins: [])
        provider.request(TrendingAPI.trendingRepositories(language: "", since: "daily")) { (result) in
        }

    }


}

