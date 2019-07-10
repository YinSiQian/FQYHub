//
//  TokenManager.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/7/10.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import Foundation

class TokenManager {
    static let shared = TokenManager()
    
    var token: Token?
    
    var isAuth: Bool {
        return token != nil
    }
    
    private init() {
        let tokenData = UserDefaults.standard.object(forKey: "token") as? [String: Any] ?? [:]
        token = Token(JSON: tokenData)
        print("token ---->\(token as Any)")
    }
    
    
    public func save() {
        
        guard let _token = token else {
            return
        }
        
        let mirror = Mirror(reflecting: _token)
        var data: Dictionary = [String : Any]()
        for (key, value) in mirror.children {
            data.updateValue(value, forKey: key!)
        }
        UserDefaults.standard.set(data, forKey: "token")
        
        
    }
}
