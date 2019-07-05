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



public enum TrendingSearchTypeSegments: Int {
    
    case repositories, users
    
    var currentTitle: String {
        switch self {
        case .repositories: return "Repositories"
        case .users: return "User"
        }
    }
}

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
    
    var trendingSegmentSelection: Observable<TrendingSegments> = Observable<TrendingSegments>.of(.daily)
    
    var trendingRepositoryResult: Observable<[TrendingRepository]> = Observable.of([])
    
    var trendingUserResult: Observable<[TrendingUser]> = Observable.of([])
    
    let provider = RequestAPI(trendingProvide: TrendingRequest.trendingNetworking())
    
    init(selection: Observable<TrendingSegments>) {
        super.init()
        self.trendingSegmentSelection = selection
        
        trendingRepositoryResult = trendingSegmentSelection.flatMapLatest { (segment) -> Observable<[TrendingRepository]> in
            let since = segment.paramValue
            
            return self.provider.trendingRepositories(language: "", since: since).asObservable()
        }
        
        trendingUserResult = trendingSegmentSelection.flatMapLatest { (segment) -> Observable<[TrendingUser]> in
            let since = segment.paramValue
            
            return self.provider.trendingDevelopers(language: "", since: since).asObservable()
        }
    
    }
    
}
