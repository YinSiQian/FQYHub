//
//  SearchViewModel.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/7/15.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

public enum SearchSelection {
    
    case users(items: [SearchSelectionItem])
    case repos(items: [SearchSelectionItem])
}

public enum SearchSelectionItem {
    
    case user(cellViewModel: UserSearchCellViewModel)
    case repo(cellViewModel: TrendingRepositoryCellViewModel)
    
}

extension SearchSelection: SectionModelType {
    
    public init(original: SearchSelection, items: [SearchSelectionItem]) {
        switch original {
        case .users(let items): self = .users(items: items)
        case .repos(let items): self = .repos(items: items)
        }
    }
    
    
    public typealias Item = SearchSelectionItem
    
    var title: String {
        switch self {
        case .repos(items: _): return "repos"
        case .users(items: _): return "users"
        }
    }
    
    public var items: [SearchSelectionItem] {
        switch self {
        case .repos(let items): return items.map { $0}
        case .users(let items): return items.map { $0}
        }
    }
    
    
}



class SearchViewModel: NSObject {

    var page = 1
    
    struct Input {
        let keyworkTrigger: Observable<String>
        let segmentSelection: Observable<TrendingSearchTypeSegments>
        let footerRefresh: Observable<Void>
        let userSelect: Driver<SearchSelectionItem>
    }
    
    
    
    struct Output {
        let footerEndRefresh: Observable<Bool>
        let noMoreData: Observable<Bool>
        let searchSelection: BehaviorRelay<[SearchSelection]>
        let repoSelected: Driver<Repository>
        let userSelected: Driver<User>
    }
    
    let keyword = BehaviorRelay(value: "")
    
    func transform(input: Input) -> Output {
        
        let keyworkDriver = input.keyworkTrigger
        let selectionType = input.segmentSelection
        let elements = BehaviorRelay<[SearchSelection]>(value: [])
        let footerAction = input.footerRefresh
        let userSelection = input.userSelect

        let repoSearch = BehaviorRelay<RepositorySearchModel>.init(value: RepositorySearchModel())
        let userSearch = BehaviorRelay<UserSearchModel>.init(value: UserSearchModel())
        
        input.keyworkTrigger.asDriverOnErrorJustComplete().skip(1).debounce(0.5).distinctUntilChanged().asObservable()
            .bind(to: keyword).disposed(by: disposeBag)
        
        keyworkDriver.flatMapLatest { (keyword) -> Observable<RxSwift.Event<RepositorySearchModel>> in
            return singleProvider.searchRepositories(query: keyword, page: self.page).asObservable().materialize()
        }.subscribe(onNext: { (event) in
            switch event {
                case .next(let element):
                    repoSearch.accept(element)
                default: break
            }
        }).disposed(by: disposeBag)
        
        keyworkDriver.flatMapLatest { (keyword) -> Observable<RxSwift.Event<UserSearchModel>> in
            
            return singleProvider.searchUsers(query: keyword, page: self.page).asObservable().materialize()
            
        }.subscribe(onNext: { (event) in
            switch event {
            case .next(let element):
                userSearch.accept(element)
            default: break
            }
        }).disposed(by: disposeBag)
        
        footerAction.flatMapLatest { () -> Observable<RxSwift.Event<UserSearchModel>> in
            
            return singleProvider.searchUsers(query: self.keyword.value, page: self.page).asObservable().materialize()

        }.subscribe(onNext: { (event) in
            switch event {
            case .next(let element):
                userSearch.accept(element)
            default: break
            }
        }).disposed(by: disposeBag)
        
        footerAction.flatMapLatest { () -> Observable<RxSwift.Event<RepositorySearchModel>> in
            
            return singleProvider.searchRepositories(query: self.keyword.value, page: self.page).asObservable().materialize()
            
            }.subscribe(onNext: { (event) in
                switch event {
                case .next(let element):
                    repoSearch.accept(element)
                default: break
                }
            }).disposed(by: disposeBag)
        
        Observable.combineLatest(repoSearch, userSearch, selectionType).map { (repoModel, userModel, selection) -> [SearchSelection] in
            var elements = [SearchSelection]()
            switch selection {
                case .users:
                    let users = userModel.items.map({ (user) -> SearchSelectionItem in
                        let cellViewModel = UserSearchCellViewModel(with: user)
                        return SearchSelectionItem.user(cellViewModel: cellViewModel)
                    })
                    if users.count > 0 {
                        elements.append(SearchSelection.users(items: users))
                    }
                case .repositories:
                    let repos = repoModel.items.map({ (repo) -> SearchSelectionItem in
                        let cellViewModel = TrendingRepositoryCellViewModel(with: repo)
                        return SearchSelectionItem.repo(cellViewModel: cellViewModel)
                    })
                    if repos.count > 0 {
                        elements.append(SearchSelection.repos(items: repos))
                }
            }
            return elements
        }.bind(to: elements).disposed(by: disposeBag)
        
        
        let repositorySelected = PublishSubject<Repository>()
        let userSelected = PublishSubject<User>()
        
        userSelection.drive(onNext: { (searchItem) in
            
            switch searchItem {
                case .repo(let cellViewModel):
                    repositorySelected.onNext(cellViewModel.repo)
                case .user(let cellViewModel):
                    userSelected.onNext(cellViewModel.user)
            }
            
        }).disposed(by: disposeBag)
        
        let footerEndRefresh = Observable.merge( elements.map { _ in true } )
        
        let noMoreData = elements.flatMap { (model) -> Observable<Bool> in
            
            return Observable<Bool>.of(model.count < self.page * Configs.PageHelper.rows)
            
        }
        
        let repoDetail = repositorySelected.map { (repo) -> Repository in
            return repo
        }.asDriverOnErrorJustComplete()
        
        let userDetail = userSelected.map { (user) -> User in
            return user
        }.asDriverOnErrorJustComplete()
        
        return Output(footerEndRefresh: footerEndRefresh, noMoreData: noMoreData, searchSelection: elements, repoSelected: repoDetail, userSelected: userDetail)
        
    }
    
}
