//
//  GithubAPIs.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/6/27.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import Foundation
import Moya


public enum GithubAPIs {
    case trending(language: String, since: String)
}

extension GithubAPIs: TargetType {
    
    public var baseURL: URL {
        switch self {
        case .trending(language: _, since: _):
            return Configs.Network.trendingBaseURL.url!
      
        }
    }
    
    public var path: String {
        switch self {
        case .trending(language: _, since: _):
            return "repositories"
      
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .trending(language: _, since: _):
            return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .trending(let language, let since):
            return .requestParameters(parameters: ["language": language, "since": since], encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return [:]
    }
    
    
    
    
    
}
