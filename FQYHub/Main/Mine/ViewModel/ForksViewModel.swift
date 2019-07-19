//
//  ForksViewModel.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/7/19.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ForksViewModel: NSObject {

    
    var page = 1
    
    struct Input {
        let fullname: String
        let footerAction: Observable<Void>
        let selection: Driver<TrendingRepositoryCellViewModel>
    }
    
    struct Output {
        let endRefresh: Observable<Bool>
        let noMoreData: Observable<Bool>
        let starsElements: BehaviorRelay<[TrendingRepositoryCellViewModel]>
        let userSelection: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        
        let name = input.fullname
        let userSelection = input.selection
        
        let datas = BehaviorRelay<[TrendingRepositoryCellViewModel]>(value: [])
        
        let userSelectionValue = PublishSubject<String>()
        
        userSelection.drive(onNext: { (cellViewModel) in
            
            userSelectionValue.onNext(cellViewModel.repo.fullname ?? "")
                
        }).disposed(by: disposeBag)
        
        input.footerAction.flatMapLatest { () -> Observable<[Repository]> in
            return singleProvider.forks(fullname: name, page: self.page).asObservable()
            
            }.subscribe(onNext: { (repos) in
                
                var elements = [TrendingRepositoryCellViewModel]()
                for repo in repos {
                    let cellModel = TrendingRepositoryCellViewModel(with: repo)
                    elements.append(cellModel)
                }
                datas.accept(datas.value + elements)
                if repos.count > 0 {
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
