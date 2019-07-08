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
}

extension GithubAPI: TargetType {
    var baseURL: URL {
        return Configs.Network.githubBaseURL.url!
    }
    
    var path: String {
        switch self {
        case .repository(let name):
            return "repos/\(name)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .repository(fullName: _):
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
      
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
    
    
}
