//
//  Token.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/7/10.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import Foundation
import ObjectMapper

struct Token: Mappable {
    
    var access_token: String?

    var scope: String?
    
    var token_type: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        access_token <- map["access_token"]
        scope <- map["scope"]
        token_type <- map["token_type"]
    }
    
    
}
