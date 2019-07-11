//
//  UserReposViewModel.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/7/11.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UserReposViewModel: NSObject {
    
    
    var page = 1
    
    struct Input {
        let username: String
        let footerRefresh: Observable<Void>
    }

    let repos = BehaviorRelay<[TrendingRepositoryCellViewModel]>(value: [])

    var footerEndRefresh = Observable<Bool>.of(true)
    
    var noMoreData = Observable<Bool>.of(false)
    
    init(input: Input) {
        super.init()
        let refresh = input.footerRefresh
        let name = input.username
        
        let data = refresh.flatMapLatest { _ in
            singleProvider.userRepos(username: name, page: self.page).asObservable()
        }
        
        data.subscribe(onNext: { (repos) in
            
            var elements = [TrendingRepositoryCellViewModel]()
            for repo in repos {
                elements.append(TrendingRepositoryCellViewModel(with: repo))
            }
            if elements.count > 0 {
                self.page += 1
            }
         
        
            self.repos.accept(self.repos.value + elements)
        }).disposed(by: disposeBag)
        
        footerEndRefresh = Observable.merge( self.repos.map { _ in true } )
        
        
        
    }
    
    
    
}
