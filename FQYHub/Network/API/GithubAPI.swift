//
//  GithubAPI.swift
//  FQYHub
//
//  Created by ysq on 2019/7/5.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import Foundation
import Moya

enum GithubAPI {
    case repository(fullName: String)
    case user(owner: String)
    case profile
}

extension GithubAPI: TargetType {
    var baseURL: URL {
        return Configs.Network.githubBaseURL.url!
    }
    
    var path: String {
        switch self {
        case .repository(let name):
            return "repos/\(name)"
        case .user(let name):
            return "users/\(name)"
        case .profile:
            return "user"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .repository(fullName: _):
            return .get
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .repository(fullName: _):
            return .requestPlain
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        if let _token = TokenManager.shared.token {
            return ["Authorization": "token \(_token.access_token!)"]
        }
        return nil
    }
    
    
    
    
}
