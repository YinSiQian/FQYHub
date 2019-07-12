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
    
    let githubProvider: GithubRequest
    
    init(trendingProvide: TrendingRequest, githubProvider: GithubRequest) {
        self.trendingProvider = trendingProvide
        self.githubProvider = githubProvider
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
    
    func createAccessToken(clientId: String, clientSecrect: String, code: String) -> Single<Token> {
        return Single.create { single in
            let params = ["client_id": clientId, "client_secret": clientSecrect, "code": code]
            Alamofire.request("https://github.com/login/oauth/access_token",
                              method: .post,
                              parameters: params,
                              encoding: URLEncoding.default,
                              headers: ["Accept": "application/json"])
                .responseJSON(completionHandler: { (response) in
                    if let error = response.error {
                        single(.error(error))
                        return
                    }
                    if let json = response.result.value as? [String: Any] {
                        print(json)
                        if let token = Mapper<Token>().map(JSON: json) {
                            single(.success(token))
                            return
                        }
                    }
                    single(.error(RxError.unknown))
                })
            return Disposables.create {}
        }.observeOn(MainScheduler.instance)
        
    }
    
    func profile() -> Single<User> {
        return requestObject(.profile, T: User.self)
    }
    
}

extension RequestAPI {
    
    func repository(fullname: String) -> Single<Repository> {
        return requestObject(.repository(fullName: fullname), T: Repository.self)
    }
    
    func user(owner: String) -> Single<User> {
        return requestObject(.user(owner: owner), T: User.self)
    }
    
    func userRepos(username: String, page: Int) -> Single<[Repository]> {
        return requestArray(.userRepos(username: username, page: page), T: Repository.self)
    }
    
    func userFollowers(username: String, page: Int) -> Single<[User]> {
        return requestArray(.userFollower(username: username, page: page), T: User.self)
    }
    
    func userFollowing(username: String, page: Int) -> Single<[User]> {
        return requestArray(.userFollower(username: username, page: page), T: User.self)
    }
    
}

extension RequestAPI {
    
    private func requestObject<T: BaseMappable>(_ target: GithubAPI, T: T.Type) -> Single<T> {
        return githubProvider.request(target).asObservable().mapObject(T.self).catchError({ (error) -> Observable<T> in
            print("error handle ----> \(error.localizedDescription)")
            return Observable.of()
        }).asSingle()
    }
    
    private func requestArray<T: BaseMappable>(_ target: GithubAPI, T: T.Type) -> Single<[T]> {
        return githubProvider.request(target)
            .share(replay: 1)
            .asObservable()
            .mapArray(T.self)
            .catchError({ (error) -> Observable<[T]> in
                print("error handle----> \(error.localizedDescription)")
                return Observable.just([])
            }).asSingle()
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
