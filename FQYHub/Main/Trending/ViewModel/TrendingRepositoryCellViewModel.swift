//
//  TrendingRepositoryCellViewModel.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/7/5.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public class TrendingRepositoryCellViewModel {
    
    let content: Driver<String>
    let name: Driver<String>
    let avatarUlr: Driver<URL?>
    let languageColor: Driver<UIColor>
    let language: Driver<String?>
    let stars: Driver<String>
    let periodStars: Driver<String>
    
    let repository: TrendingRepository
    
    init(with repository: TrendingRepository, since: TrendingSegments) {
        self.repository = repository
        name = Driver.just("\(repository.fullname ?? "")")
        avatarUlr = Driver.just(repository.avatarUrl?.url)
        content = Driver.just("\(repository.descriptionField ?? "")")
        languageColor = Driver.just(UIColor.color(withHexString: repository.languageColor))
        language = Driver.just("\(repository.language ?? "")")
        stars = Driver.just("\(repository.stars ?? 0)")
        periodStars = Driver.just("\(repository.currentPeriodStars ?? 0) \(since.currentTitle)")
    }
    
    
}
