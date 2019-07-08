//
//  TrendingViewModel.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/6/27.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import Foundation
import RxSwift
import Moya_ObjectMapper
import ObjectMapper
import RxCocoa
import Moya


public enum TrendingSearchTypeSegments: Int {
    
    case repositories, users
    
    var currentTitle: String {
        switch self {
        case .repositories: return "Repositories"
        case .users: return "User"
        }
    }
}

public enum TrendingSegments: Int {
    
    case daily, weekly, monthly
    
    var currentTitle: String {
        switch self {
        case .daily:
            return "daily"
        case .weekly:
            return "weekly"
        case .monthly:
            return "monthly"
        }
    }
    
    var paramValue: String {
        switch self {
        case .daily:
            return "daily"
        case .weekly:
            return "weekly"
        case .monthly:
            return "monthly"
        }
    }
    
}

class TrendingViewModel: NSObject {
    
    var trendingSegmentSelection: Observable<TrendingSegments> = Observable<TrendingSegments>.of(.daily)
    
    var trendingRepositoryResult: Observable<[TrendingRepository]> = Observable.of([])
    
    var trendingUserResult: Observable<[TrendingUser]> = Observable.of([])
    
    var trendingType: Observable<TrendingSearchTypeSegments> = Observable<TrendingSearchTypeSegments>.of(.repositories)
    
    let provider = singleProvider
    
    let selectionItem: Driver<TrendingSectionItem>
    
    //output
    var elements = BehaviorRelay<[TrendingSection]>(value: [])

    var userSelected = Driver<String>.just("")
    
    var repositorySelected = Driver<String>.just("")
    
    init(selection: Observable<TrendingSegments>,
         trendingType: Observable<TrendingSearchTypeSegments>,
         selectionItem: Driver<TrendingSectionItem>) {
        self.selectionItem = selectionItem
        super.init()
        self.trendingSegmentSelection = selection
        self.trendingType = trendingType
        
        trendingRepositoryResult = trendingSegmentSelection.flatMapLatest { (segment) -> Observable<[TrendingRepository]> in
            let since = segment.paramValue
            
            return self.provider.trendingRepositories(language: "", since: since).asObservable()
        }
        
        trendingUserResult = trendingSegmentSelection.flatMapLatest { (segment) -> Observable<[TrendingUser]> in
            let since = segment.paramValue
            
            return self.provider.trendingDevelopers(language: "", since: since).asObservable()
        }
        
        Observable.combineLatest(trendingUserResult, trendingRepositoryResult, selection, trendingType).map { (userElements, repositoryElements, since, type) -> [TrendingSection] in
            var elements: [TrendingSection] = []
            switch type {
                case .repositories:
                    let repositories = repositoryElements.map({ (repository) -> TrendingSectionItem in
                        let item = TrendingSectionItem.trendingRepositoriesItem(viewModel: TrendingRepositoryCellViewModel(with: repository, since: since))
                        return item
                    })
                    if !repositories.isEmpty {
                        elements.append(TrendingSection.repositories(items: repositories))
                    }
                
                case .users:
                    let users = userElements.map({ (user) -> TrendingSectionItem in
                        return TrendingSectionItem.trendingUserItem(viewModel: TrendingUserCellViewModel(with: user))
                    })
                    if !users.isEmpty {
                        elements.append(TrendingSection.users(items: users))
                    }
            }
            return elements
        }.bind(to: elements).disposed(by: disposeBag)
        
        let repositorySelected = PublishSubject<String>()
        let userSelected = PublishSubject<String>()
        
        
        selectionItem.drive(onNext: { (item) in
            switch item {
                case .trendingRepositoriesItem(let viewModel):
                    viewModel.name.drive(onNext: { (fullName) in
                        
                        repositorySelected.onNext(fullName)
                    }).disposed(by: disposeBag)
                case .trendingUserItem(let viewModel):
                    viewModel.name.drive(onNext: { (username) in
                        userSelected.onNext(username)
                    }).disposed(by: disposeBag)
            }
        }).disposed(by: disposeBag)
    
        self.repositorySelected = repositorySelected.map({ (name) -> String in
            return name
        }).asDriverOnErrorJustComplete()
        
        self.userSelected = userSelected.map({ (name) -> String in
            return name
        }).asDriverOnErrorJustComplete()
        
    }
    
}
