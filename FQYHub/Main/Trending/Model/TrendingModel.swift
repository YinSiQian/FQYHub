//
//  Repository.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/6/27.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import Foundation
import ObjectMapper

enum TrendingUserType: String {
    case user
    case organization
}

struct TrendingRepository: Mappable {
    
    var author: String?
    var name: String?
    var url: String?
    var descriptionField: String?
    var language: String?
    var languageColor: String?
    var stars: Int?
    var forks: Int?
    var currentPeriodStars: Int?
    var builtBy: [TrendingUser]?
    
    var fullname: String? {
        return "\(author ?? "")/\(name ?? "")"
    }
    
    var avatarUrl: String? {
        return builtBy?.first?.avatar
    }
    
    init?(map: Map) {}
    init() {}
    
    mutating func mapping(map: Map) {
        author <- map["author"]
        name <- map["name"]
        url <- map["url"]
        descriptionField <- map["description"]
        language <- map["language"]
        languageColor <- map["languageColor"]
        stars <- map["stars"]
        forks <- map["forks"]
        currentPeriodStars <- map["currentPeriodStars"]
        builtBy <- map["builtBy"]
    }
}

extension TrendingRepository: Equatable {
    static func == (lhs: TrendingRepository, rhs: TrendingRepository) -> Bool {
        return lhs.fullname == rhs.fullname
    }
}

struct TrendingUser: Mappable {
    
    var username: String?
    var name: String?
    var url: String?
    var avatar: String?
    var repo: TrendingRepository?
    var type: TrendingUserType = .user
    
    init?(map: Map) {}
    init() {}
    
    mutating func mapping(map: Map) {
        username <- map["username"]
        name <- map["name"]
        url <- map["url"]
        avatar <- map["avatar"]
        repo <- map["repo"]
        type <- map["type"]
        repo?.author = username
    }
}

extension TrendingUser: Equatable {
    
    static func == (lhs: TrendingUser, rhs: TrendingUser) -> Bool {
        return lhs.username == rhs.username
    }
    
}
