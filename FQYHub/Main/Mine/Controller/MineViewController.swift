//
//  MineViewController.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/7/4.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import UIKit
import SafariServices

private let loginURL = URL(string: "http://github.com/login/oauth/authorize?client_id=\(Keys.github.appId)&scope=user+repo+notifications+read:org")!
private let callbackURLScheme = "FQYHub"

class MineViewController: BaseViewController {

    private var _authSession: Any?
    
    private var authSession: SFAuthenticationSession? {
        get {
            return _authSession as? SFAuthenticationSession
        }
        set {
            _authSession = newValue
        }
    }
    
    private var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    private func setupSubviews() {
        
        if !TokenManager.shared.isAuth {
            loginBtn = UIButton()
            loginBtn.setTitle("Auth Login", for: .normal)
            loginBtn.setTitleColor(.white, for: .normal)
            loginBtn.backgroundColor = LightTheme().primary
            loginBtn.layer.cornerRadius = 22;
            loginBtn.layer.masksToBounds = true
            view.addSubview(loginBtn)
            
            loginBtn.rx.tap.subscribe(onNext: { [weak self] in
                
                self?.login()
                
            }).disposed(by: disposeBag)
            
            loginBtn.snp.makeConstraints { (make) in
                make.center.equalTo(self.view)
                make.height.equalTo(44)
                make.left.equalTo(self.view).offset(15)
                make.right.equalTo(self.view).offset(-15)
            }
        }
        
       
    }

    private func login() {
        
        self.authSession = SFAuthenticationSession(url: loginURL, callbackURLScheme: callbackURLScheme, completionHandler: { (callbackUrl, error) in
            print("callback url --->\(String(describing: callbackUrl?.absoluteString))")
            if let error = error {
                print(error.localizedDescription)
            }
            if let codeValue = callbackUrl?.queryParameters?["code"] {
                
                singleProvider.createAccessToken(clientId: Keys.github.appId, clientSecrect: Keys.github.apiKey, code: codeValue).subscribe(onSuccess: { (token) in
                    
                    TokenManager.shared.token = token
                    TokenManager.shared.save()
                    
                    singleProvider.profile().subscribe(onSuccess: { (user) in
                        
                        print(user)
                        
                    }).disposed(by: disposeBag)
                    
                }, onError: { (error) in
                    self.view.showFail(with: error.localizedDescription)
                }).disposed(by: disposeBag)
            }
        })
        self.authSession?.start()
    }

}
