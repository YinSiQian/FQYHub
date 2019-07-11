//
//  MineViewModel.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/7/11.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SafariServices

private let loginURL = URL(string: "http://github.com/login/oauth/authorize?client_id=\(Keys.github.appId)&scope=user+repo+notifications+read:org")!
private let callbackURLScheme = "FQYHub"

class MineViewModel: NSObject {
    
    private var _authSession: Any?
    
    private var authSession: SFAuthenticationSession? {
        get {
            return _authSession as? SFAuthenticationSession
        }
        set {
            _authSession = newValue
        }
    }
    
    struct Input {
        let oAuthTrigger: Driver<Void>
    }
    
    struct Output {
        let actionCompection: Driver<Void>
    }
    
    let code = PublishSubject<String>()
    
    let saveAction = PublishSubject<Void>()
    
    func transform(input: Input) -> Output {
        
        let oAuthTrigger = input.oAuthTrigger
        
        let complection = PublishSubject<Void>()
        
        oAuthTrigger.drive(onNext: { () in
            self.authSession = SFAuthenticationSession(url: loginURL, callbackURLScheme: callbackURLScheme, completionHandler: { (callbackUrl, error) in
                if let error = error {
                    print("\(error.localizedDescription)")
                }
                if let codeValue = callbackUrl?.queryParameters?["code"] {
                    self.code.onNext(codeValue)
                }
            })
            self.authSession?.start()
        }).disposed(by: disposeBag)
        
        code.flatMapLatest { (code) -> Observable<RxSwift.Event<Token>>  in
            let clientId = Keys.github.appId
            let clientSecret = Keys.github.apiKey
            return singleProvider.createAccessToken(clientId: clientId, clientSecrect: clientSecret, code: code).asObservable()
                .materialize()
        }.subscribe(onNext: { [weak self] (event) in
            switch event {
                case .next(let token):
                    TokenManager.shared.token = token
                    TokenManager.shared.save()
                    self?.saveAction.onNext(())
                case .error(let error):
                    print("error \(error.localizedDescription)")
                default: break
            }
        }).disposed(by: disposeBag)


        saveAction.flatMapLatest { () -> Observable<RxSwift.Event<User>> in
            
            return singleProvider.profile().asObservable().materialize()
            
        }.subscribe(onNext: { (event) in
            switch event {
                case .next(let user):
                    user.save()
                    complection.onNext(())
                default: break
            }
        }).disposed(by: disposeBag)
        
        return Output(actionCompection: complection.asDriverOnErrorJustComplete())
        
    }
    
}
