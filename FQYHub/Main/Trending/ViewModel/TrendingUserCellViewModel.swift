//
//  TrendingUserCellViewModel.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/7/5.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public class TrendingUserCellViewModel {
    
    let trendingUser: TrendingUser
    
    let name: Driver<String>
    let content: Driver<String>
    let avatarUlr: Driver<URL?>
    let languageColor: Driver<UIColor>
    let language: Driver<String?>
    let username: Driver<String>
    
    let user: User
    
    init(with trendingUser: TrendingUser) {
        self.user = User()
        self.trendingUser = trendingUser
        name = Driver.just("\(trendingUser.name ?? "") (\(trendingUser.username ?? "")) ")
        content = Driver.just("\(trendingUser.repo?.fullname ?? "")")
        avatarUlr = Driver.just(trendingUser.avatar?.url)
        languageColor = Driver.just(UIColor.color(withHexString: trendingUser.repo?.languageColor))
        language = Driver.just(trendingUser.repo?.language)
        username = Driver.just("\(trendingUser.username ?? "")")
    }
    
    init(with user: User) {
        self.trendingUser = TrendingUser()
        self.user = user
        name = Driver.just("\(user.login ?? "")")
        content = Driver.just("\("")")
        avatarUlr = Driver.just(user.avatarUrl?.url)
        languageColor = Driver.just(UIColor.clear)
        language = Driver.just("")
        username = Driver.just("")
    }
    
}
