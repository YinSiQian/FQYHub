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
    
    let user: TrendingUser
    
    let name: Driver<String>
    let content: Driver<String>
    let avatarUlr: Driver<URL?>
    let languageColor: Driver<UIColor>
    let language: Driver<String?>
    
    init(with user: TrendingUser) {
        self.user = user
        name = Driver.just("\(user.name ?? "") (\(user.username ?? "")) ")
        content = Driver.just("\(user.repo?.fullname ?? "")")
        avatarUlr = Driver.just(user.avatar?.url)
        languageColor = Driver.just(UIColor.color(withHexString: user.repo?.languageColor))
        language = Driver.just(user.repo?.language)
    }
    
}
