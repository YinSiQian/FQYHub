//
//  WatchersViewModel.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/7/19.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WatchersViewModel: NSObject {

    var page = 1
    
    struct Input {
        let fullname: String
        let footerAction: Observable<Void>
        let selection: Driver<TrendingUserCellViewModel>
    }
    
    struct Output {
        let endRefresh: Observable<Bool>
        let noMoreData: Observable<Bool>
        let starsElements: BehaviorRelay<[TrendingUserCellViewModel]>
        let userSelection: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        
        let name = input.fullname
        let userSelection = input.selection
        
        let datas = BehaviorRelay<[TrendingUserCellViewModel]>(value: [])
        
        let userSelectionValue = PublishSubject<String>()
        
        userSelection.drive(onNext: { (cellViewModel) in
            
            cellViewModel.name.drive(onNext: { (name) in
                userSelectionValue.onNext(name)
                
            }).disposed(by: disposeBag)
        }).disposed(by: disposeBag)
        
        input.footerAction.flatMapLatest { () -> Observable<[User]> in
            return singleProvider.watchers(fullname: name, page: self.page).asObservable()
            
            }.subscribe(onNext: { (users) in
                
                var elements = [TrendingUserCellViewModel]()
                for user in users {
                    let cellModel = TrendingUserCellViewModel(with: user)
                    elements.append(cellModel)
                }
                datas.accept(datas.value + elements)
                if users.count > 0 {
                    self.page += 1
                }
            }).disposed(by: disposeBag)
        
        let footerEndRefresh = Observable.merge( datas.map { _ in true } )
        
        let noMoreData = datas.flatMap { (models) -> Observable<Bool> in
            return Observable<Bool>.of(models.count < self.page * Configs.PageHelper.rows)
        }
        
        return Output(endRefresh: footerEndRefresh,
                      noMoreData: noMoreData,
                      starsElements: datas,
                      userSelection: userSelectionValue.asDriverOnErrorJustComplete())
        
    }
}
