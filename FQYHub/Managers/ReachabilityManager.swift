//
//  ReachabilityManager.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/6/27.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import UIKit
import RxSwift
import Reachability

func checkNetworkIsConnection() -> Observable<Bool> {
    return ReachabilityManager.shared.reach
}

private class ReachabilityManager: NSObject {
    
    static let shared = ReachabilityManager()
    
    private let reachability = Reachability()
    
    //只缓存一个值
    let reachSubject = ReplaySubject<Bool>.create(bufferSize: 1)
    var reach: Observable<Bool> {
        return reachSubject.asObserver()
    }
    
    override init() {
        super.init()
        
        reachability?.whenReachable = { reachability in
            DispatchQueue.main.async {
                print("reachable")
                self.reachSubject.onNext(true)
            }
        }
        
        reachability?.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                print("unreachable")
                self.reachSubject.onNext(false)
            }
        }
        
        do {
            try reachability?.startNotifier()
            reachSubject.onNext(reachability?.connection != .none)
        } catch {
            print("unable to start network monitoring")
        }
    }

}
