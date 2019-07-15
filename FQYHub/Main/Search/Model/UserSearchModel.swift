//
//  UserSearchModel.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/7/15.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import Foundation
import ObjectMapper

struct UserSearchModel: Mappable {
    
    var items: [User] = []
    var totalCount: Int = 0
    var incompleteResults: Bool = false
    var moreData: Bool = false
    
    init?(map: Map) {}
    init() {}
    
    mutating func mapping(map: Map) {
        items <- map["items"]
        totalCount <- map["total_count"]
        incompleteResults <- map["incomplete_results"]
        moreData = items.count > 0
    }
    
    
}
