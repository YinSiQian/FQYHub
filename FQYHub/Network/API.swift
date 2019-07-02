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
}
