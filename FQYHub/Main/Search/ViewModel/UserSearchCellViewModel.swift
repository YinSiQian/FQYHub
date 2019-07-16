//
//  UserSearchCellViewModel.swift
//  FQYHub
//
//  Created by ysq on 2019/7/15.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public class UserSearchCellViewModel {
    
    let user: User
    
    let name: Driver<String>
    let stars: Driver<String>
    let repos: Driver<String>
    let followers: Driver<String>
    let des: Driver<String>
    let avatar: Driver<String>
    
    init(with user: User) {
        self.user = user
        name = Driver.just("\(user.name ?? "\(user.login ?? "")" )")
        stars = Driver.just("Stars \(user.starredRepositoriesCount ?? 0)")
        repos = Driver.just("Repos \(user.repositoriesCount ?? 0)")
        followers = Driver.just("Followers \(user.followers ?? 0)")
        des = Driver.just("\(user.descriptionField ?? "This user has no personal description yet!")")
        avatar = Driver.just("\(user.avatarUrl ?? "")")
    }
    
}
