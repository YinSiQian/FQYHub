//
//  RepositoryDetailViewModel.swift
//  FQYHub
//
//  Created by ysq on 2019/7/5.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import Foundation

class RepositoryDetailViewModel: NSObject {
    
    let provider = RequestAPI(trendingProvide: TrendingRequest.trendingNetworking(), githubProvider: GithubRequest.githubNetworking())
    
    
    
}
