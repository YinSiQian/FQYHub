//
//  API.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/6/27.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import Foundation
import RxSwift


protocol API {
    
    func trendingRepositories(language: String, since: String) -> Single<[TrendingRepository]>
    
    func trendingDevelopers(language: String, since: String) -> Single<[TrendingUser]>
    
    func repository(fullname: String) -> Single<Repository>
    
    func user(owner: String) -> Single<User>
    
    func createAccessToken(clientId: String, clientSecrect: String, code: String) -> Single<Token>
    
    func profile() -> Single<User>
    
    func userRepos(username: String, page: Int) -> Single<[Repository]>
    
    func userFollowers(username: String, page: Int) -> Single<[User]>
    
    func userFollowing(username: String, page: Int) -> Single<[User]>
    
    func searchUsers(query: String, page: Int) -> Single<UserSearchModel>
    
    func searchRepositories(query: String, page: Int) -> Single<RepositorySearchModel>
}
