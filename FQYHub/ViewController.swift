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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let obserable = Observable<TrendingSegments>.just(TrendingSegments.daily)
        let viewModel = TrendingViewModel(selection: obserable)

        viewModel.trendingRepositoryResult.subscribe { (event) in
            switch event {
            case .next(let items):
                print("items----> \(items)")
                
            default: break
            }
        }.disposed(by: DisposeBag())
        
        
        
        
        
        
//        let provider = MoyaProvider<TrendingAPI>(plugins: [])
//        provider.request(TrendingAPI.trendingRepositories(language: "", since: "daily")) { (result) in
//            do {
//                let response = try result.get()
//                let value = try response.mapJSON()
//
//                print("value ----> \(value)")
//            } catch {
//
//            }
//        }
//
    }


}

