//
//  TrendingViewModel.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/6/27.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import Foundation
import RxSwift
import Moya_ObjectMapper
import ObjectMapper
import RxCocoa
import Moya




public enum TrendingSegments: Int {
    
    case daily, weekly, monthly
    
    var currentTitle: String {
        switch self {
        case .daily:
            return "今天"
        case .weekly:
            return "本周"
        case .monthly:
            return "本月"
        }
    }
    
    var paramValue: String {
        switch self {
        case .daily:
            return "daily"
        case .weekly:
            return "weekly"
        case .monthly:
            return "monthly"
        }
    }
    
}

let trendingProvider = MoyaProvider<TrendingAPI>()

class TrendingViewModel: NSObject {
    
    var trendingSegmentSelection: Observable<TrendingSegments> = Observable.just(TrendingSegments.daily)
    
    var trendingRepositoryResult: Observable<[TrendingRepository]> = Observable.just([])
    
    let provider = RequestAPI(trendingProvide: TrendingRequest.trendingNetworking())
    
    override init() {
        super.init()
    }
    
    convenience init(selection: Observable<TrendingSegments>) {
        self.init()
        self.trendingSegmentSelection = selection
        trendingRepositoryResult = Observable.just([])
        
        
//        let provider = RequestAPI(trendingProvide: TrendingRequest.trendingNetworking())
       
        trendingSegmentSelection.flatMapLatest({ (segment) -> Observable<RxSwift.Event<[TrendingRepository]>> in
            let since = segment.paramValue

            return self.provider.trendingRepositories(language: "", since: since).asObservable().materialize()

        }).subscribe(onNext: { (event) in
            switch event {
            case .next(let items):
                print("items--->\(items)")
                self.trendingRepositoryResult = Observable.just(items)
            default: break
            }
        }).disposed(by: DisposeBag())


    }
    
}
