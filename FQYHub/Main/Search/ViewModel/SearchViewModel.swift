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

    var repoPage = 1
    
    var userPage = 1
    
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
        
    input.keyworkTrigger.asDriverOnErrorJustComplete().skip(1).debounce(0.5).distinctUntilChanged().asObservable().bind(to: keyword).disposed(by: disposeBag)
        
        keyworkDriver.filter { (keyword) -> Bool in
            print("new key word \(keyword) old key \(self.keyword.value)")
            return !keyword.isEmpty && self.keyword.value != keyword
            
        }.flatMapLatest { (keyword) -> Observable<RxSwift.Event<RepositorySearchModel>> in
            self.repoPage = 1
            return singleProvider.searchRepositories(query: keyword, page: self.repoPage).asObservable().materialize()
        }.subscribe(onNext: { (event) in
            
            switch event {
            case .next(let element):
                repoSearch.accept(element)
                if element.moreData {
                    self.repoPage += 1
                }
            default: break
            }
            
        }).disposed(by: disposeBag)
        
        keyworkDriver.filter { (keyword) -> Bool in
            return !keyword.isEmpty && self.keyword.value != keyword
            
        }.flatMapLatest { (keyword) -> Observable<RxSwift.Event<UserSearchModel>> in
            
            self.userPage = 1
            return singleProvider.searchUsers(query: keyword, page: self.userPage).asObservable().materialize()
        }.subscribe(onNext: { (event) in
                
            switch event {
            case .next(let element):
                userSearch.accept(element)
                if element.moreData {
                    self.userPage += 1
                }
            default: break
            }
                
        }).disposed(by: disposeBag)
        
        footerAction.flatMapLatest { () -> Observable<RxSwift.Event<UserSearchModel>> in
            
            return singleProvider.searchUsers(query: self.keyword.value, page: self.userPage).asObservable().materialize()

        }.subscribe(onNext: { (event) in
            switch event {
            case .next(let element):
                var _element = element
                _element.items = userSearch.value.items + _element.items
                userSearch.accept(_element)
                if element.moreData {
                    self.userPage += 1
                }
             
            default: break
            }
        }).disposed(by: disposeBag)
        
        footerAction.flatMapLatest { () -> Observable<RxSwift.Event<RepositorySearchModel>> in
            
            return singleProvider.searchRepositories(query: self.keyword.value, page: self.repoPage).asObservable().materialize()
            
            }.subscribe(onNext: { (event) in
                switch event {
                case .next(let element):
                    var _element = element
                    _element.items = repoSearch.value.items + _element.items
                    repoSearch.accept(_element)
                    if _element.moreData {
                        self.repoPage += 1
                    }
                
                default: break
                }
            }).disposed(by: disposeBag)
        
        Observable.combineLatest(repoSearch, userSearch, selectionType).map { (repoModel, userModel, selection) -> [SearchSelection] in
            var _elements = [SearchSelection]()
            switch selection {
                case .users:
                    let users = userModel.items.map({ (user) -> SearchSelectionItem in
                        let cellViewModel = UserSearchCellViewModel(with: user)
                        return SearchSelectionItem.user(cellViewModel: cellViewModel)
                    })
                    if users.count > 0 {
                        _elements.append(SearchSelection.users(items: users))
                    }
                case .repositories:
                    let repos = repoModel.items.map({ (repo) -> SearchSelectionItem in
                        let cellViewModel = TrendingRepositoryCellViewModel(with: repo)
                        return SearchSelectionItem.repo(cellViewModel: cellViewModel)
                    })
                    if repos.count > 0 {
                        _elements.append(SearchSelection.repos(items: repos))
                }
            }
            return _elements
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
        
        
        let noMoreData = Observable.combineLatest(selectionType, userSearch, repoSearch).flatMapLatest { (segment, userResult, repoResult) -> Observable<Bool> in
            switch segment {
            case .repositories:
                return Observable<Bool>.of(!repoResult.moreData)
            case .users:
                return Observable<Bool>.of(!userResult.moreData)
            }
        }
        
        
        let repoDetail = repositorySelected.map { (repo) -> Repository in
            return repo
        }.asDriverOnErrorJustComplete()
        
        let userDetail = userSelected.map { (user) -> User in
            return user
        }.asDriverOnErrorJustComplete()
        
        return Output(footerEndRefresh: footerEndRefresh,
                      noMoreData: noMoreData,
                      searchSelection: elements,
                      repoSelected: repoDetail,
                      userSelected: userDetail)
        
    }
    
}
