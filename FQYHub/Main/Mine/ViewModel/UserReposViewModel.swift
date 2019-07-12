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
        let selection: Driver<TrendingRepositoryCellViewModel>
    }

    let repos = BehaviorRelay<[TrendingRepositoryCellViewModel]>(value: [])

    var footerEndRefresh = Observable<Bool>.of(true)
    
    var noMoreData = Observable<Bool>.of(false)
    
    var selection = Driver<String>.just("")
    
    init(input: Input) {
        super.init()
        let refresh = input.footerRefresh
        let name = input.username
        
        //点击事件绑定
        let userSelection = input.selection
        
        let userSelected = PublishSubject<String>()
        
        userSelection.drive(onNext: { (model) in
            
            userSelected.onNext(model.repo.htmlUrl ?? "")
            
        }).disposed(by: disposeBag)
        
        self.selection = userSelected.map({ (url) -> String in
            return url
        }).asDriverOnErrorJustComplete()
        
        
        let data = refresh.flatMapLatest { _ in
            singleProvider.userRepos(username: name, page: self.page).asObservable()
        }
        
        data.subscribe(onNext: { (_repos) in
            
            var elements = [TrendingRepositoryCellViewModel]()
            for repo in _repos {
                elements.append(TrendingRepositoryCellViewModel(with: repo))
            }
            if elements.count > 0 {
                self.page += 1
            }
            self.repos.accept(self.repos.value + elements)
            
        }).disposed(by: disposeBag)
        
        footerEndRefresh = Observable.merge( self.repos.map { _ in true } )
        
        self.noMoreData = self.repos.flatMap({ (models) -> Observable<Bool> in
            print(models)
            return Observable<Bool>.of( models.count < self.page * Configs.PageHelper.rows )
        })
    }
    
    
    
}
