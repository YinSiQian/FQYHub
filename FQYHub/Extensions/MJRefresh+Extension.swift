//
//  MJRefresh+Extension.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/7/11.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import Foundation
import RxSwift
import MJRefresh
import RxCocoa

extension Reactive where Base: MJRefreshComponent {
    
    var refreshing: ControlEvent<Void> {
        let source: Observable<Void> = Observable.create {
            [weak control = self.base] observer in
            if let control = control {
                control.refreshingBlock = {
                    observer.on(.next(()))
                }
            }
            return Disposables.create()
        }
        return ControlEvent(events: source)
    }
    
    //停止刷新
    var endRefreshing: Binder<Bool> {
        return Binder(base) { refresh, isEnd in
            if isEnd {
                refresh.endRefreshing()
            }
        }
    }
    
}
