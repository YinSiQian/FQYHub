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

class MineViewController: UIViewController {

    private var _authSession: Any?
    
    private var authSession: SFAuthenticationSession? {
        get {
            return _authSession as? SFAuthenticationSession
        }
        set {
            _authSession = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.authSession = SFAuthenticationSession(url: loginURL, callbackURLScheme: callbackURLScheme, completionHandler: { (callbackUrl, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let codeValue = callbackUrl?.queryParameters?["code"] {
                print(codeValue)
            }
        })
        self.authSession?.start()

    }


}
