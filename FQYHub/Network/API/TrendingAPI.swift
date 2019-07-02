//
//  TrendingAPI.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/6/27.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import Foundation
import Moya

enum TrendingAPI {
    case trendingRepositories(language: String, since: String)
    case trendingDevelopers(language: String, since: String)
    case languages

}

extension TrendingAPI: TargetType {
    
    var baseURL: URL {
        return Configs.Network.trendingBaseURL.url!
    }
    
    var path: String {
        switch self {
        case .trendingRepositories:
            return "repositories"
        case .trendingDevelopers:
            return "developers"
        case .languages:
            return "languages"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
    
    var parameters: [String: Any]? {
        var params: [String: Any] = [:]
        switch self {
        case .trendingRepositories(let language, let since),
             .trendingDevelopers(let language, let since):
            params["language"] = language
            params["since"] = since
        default: break
        }
        return params
    }
    
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        if let parameters = parameters {
            return .requestParameters(parameters: parameters, encoding: parameterEncoding)
        }
        return .requestPlain
    }

    
}
