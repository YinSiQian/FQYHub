//
//  RequestAPI.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/6/27.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper
import Moya_ObjectMapper
import Moya
import Alamofire
import RxCocoa


class RequestAPI: API {

    
    let trendingProvider: TrendingRequest
    
    init(trendingProvide: TrendingRequest) {
        self.trendingProvider = trendingProvide
    }
    
    
    
}

extension RequestAPI {
    
    func trendingRepositories(language: String, since: String) -> Single<[TrendingRepository]> {
        return trendingRequestArray(.trendingRepositories(language: language, since: since), T: TrendingRepository.self)
    }
    
    func trendingDevelopers(language: String, since: String) -> Single<[TrendingUser]> {
        return trendingRequestArray(.trendingDevelopers(language: language, since: since), T: TrendingUser.self)
    }
    
}

extension RequestAPI {
    
    private func trendingRequestArray<T: BaseMappable>(_ target: TrendingAPI, T: T.Type) -> Single<[T]> {
        return trendingProvider.request(target)
                               .share(replay: 1)                                    
                               .asObservable()
                               .mapArray(T.self)
            .catchError({ (error) -> Observable<[T]> in
                print("error handle----> \(error.localizedDescription)")
                return Observable.just([])
            }).asSingle()
        
    }
    
    
}
