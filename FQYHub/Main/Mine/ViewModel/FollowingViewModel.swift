//
//  FollowingViewModel.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/7/12.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FollowingViewModel: NSObject {

    
    var page = 1
    
    struct Input {
        let username: String
        let footerRefresh: Observable<Void>
        let selection: Driver<TrendingUserCellViewModel>
    }
    
    struct Output {
        let users: BehaviorRelay<[TrendingUserCellViewModel]>
        let footerEndRefresh: Observable<Bool>
        let noMoreData: Observable<Bool>
        let userSelection: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        
        let name = input.username
        let footer = input.footerRefresh
        let selection = input.selection
        
        let userSelection = PublishSubject<String>()
        let datas = BehaviorRelay<[TrendingUserCellViewModel]>(value: [])
        
        selection.drive(onNext: { (cellViewModel) in
            
            cellViewModel.name.drive(onNext: { (name) in
                userSelection.onNext(name)
                
            }).disposed(by: disposeBag)
            
        }).disposed(by: disposeBag)
        
        let data = footer.flatMapLatest { () -> Observable<[User]> in
            return singleProvider.userFollowing(username: name, page: self.page).asObservable()
        }
        
        data.subscribe(onNext: { (users) in
            var elements = [TrendingUserCellViewModel]()
            for user in users {
                let cellModel = TrendingUserCellViewModel(with: user)
                elements.append(cellModel)
            }
            datas.accept(datas.value + elements)
            
        }).disposed(by: disposeBag)
        
        let footerEndRefresh = Observable.merge( datas.map { _ in true } )
        
        let noMoreData = datas.flatMap { (models) -> Observable<Bool> in
            return Observable<Bool>.of(models.count < self.page * Configs.PageHelper.rows)
            
        }
        
        return Output(users: datas,
                      footerEndRefresh: footerEndRefresh,
                      noMoreData: noMoreData,
                      userSelection: userSelection.asDriverOnErrorJustComplete())
        
    }
}
