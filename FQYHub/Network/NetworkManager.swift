//
//  NetworkManager.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/6/27.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import UIKit
import Moya
import Alamofire
import RxSwift
import Security

let disposeBag = DisposeBag()

class NetworkManager<Target> where Target: Moya.TargetType {
    
    fileprivate let online: Observable<Bool>
    fileprivate let provider: MoyaProvider<Target>
    
    init(endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider<Target>.defaultEndpointMapping,
         requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
         stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider<Target>.neverStub,
         manager: Manager = MoyaProvider<Target>.defaultAlamofireManager(),
         plugins: [PluginType] = [],
         trackInflights: Bool = false,
         online: Observable<Bool> = checkNetworkIsConnection()) {
        self.online = online
        self.provider = MoyaProvider(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, manager: manager, plugins: plugins, trackInflights: trackInflights)
    }
    
    func request(_ token: Target) -> Observable<Moya.Response> {
        let request = provider.rx.request(token)
        return online
            .ignore(value: false)  // Wait until we're online
            .take(1)        // Take 1 to make sure we only invoke the API once.
            .flatMap { _ in // Turn the online state into a network request
                
                return request
                    .filterSuccessfulStatusCodes()
                    .do(onSuccess: { (response) in
                        
                    }, onError: { (error) in
                        if let error = error as? MoyaError {
                            switch error {
                            case .statusCode(let response):
                                if response.statusCode == 401 {
                                    // Unauthorized
                                    //                                    AuthManager.removeToken()
                                }
                            default: break
                            }
                        }
                    })
        }
    }

}

private func newProvider<T>(_ plugins: [PluginType]) -> NetworkManager<T> where T: TargetType {
    return NetworkManager( plugins: plugins, online: checkNetworkIsConnection())
}


protocol RequestType {
    associatedtype T: TargetType
    var provider: NetworkManager<T> { get }
}



struct TrendingRequest: RequestType {
    typealias T = TrendingAPI
    let provider: NetworkManager<TrendingAPI>
}

struct GithubRequest: RequestType {
    typealias T = GithubAPI
    let provider: NetworkManager<GithubAPI>
}

extension RequestType {
    static func githubNetworking() -> GithubRequest {
        return GithubRequest(provider: newProvider([]))
    }
}

extension GithubRequest {
    func request(_ token: GithubAPI) -> Observable<Moya.Response> {
        return self.provider.request(token)
    }
}

extension RequestType {
    static func trendingNetworking() -> TrendingRequest {
        return TrendingRequest(provider: newProvider([]))
    }
}

extension TrendingRequest {
    
    func request(_ token: TrendingAPI) -> Observable<Moya.Response> {
        let req = self.provider.request(token)
        return req
    }
}
