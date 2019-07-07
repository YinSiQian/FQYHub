//
//  Repository.swift
//  FQYHub
//
//  Created by ysq on 2019/7/5.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import Foundation
import ObjectMapper

struct License: Mappable {
    
    var key: String?
    var name: String?
    var nodeId: String?
    var spdxId: AnyObject?
    var url: AnyObject?
    
    init?(map: Map) {}
    init() {}
    
    mutating func mapping(map: Map) {
        key <- map["key"]
        name <- map["name"]
        nodeId <- map["node_id"]
        spdxId <- map["spdx_id"]
        url <- map["url"]
    }
}

struct Repository: Mappable {
    
    var archived: Bool?
    var cloneUrl: String?
    var createdAt: Date?  // Identifies the date and time when the object was created.
    var defaultBranch = "master"  // The Ref name associated with the repository's default branch.
    var descriptionField: String?  // The description of the repository.
    var fork: Bool?  // Identifies if the repository is a fork.
    var forks: Int?  // Identifies the total count of direct forked repositories
    var forksCount: Int?
    var fullname: String?  // The repository's name with owner.
    var hasDownloads: Bool?
    var hasIssues: Bool?
    var hasPages: Bool?
    var hasProjects: Bool?
    var hasWiki: Bool?
    var homepage: String?  // The repository's URL.
    var htmlUrl: String?
    var language: String?  // The name of the current language.
    var languageColor: String?  // The color defined for the current language.
    var license: License?
    var name: String?  // The name of the repository.
    var networkCount: Int?
    var nodeId: String?
    var openIssues: Int?
    var openIssuesCount: Int?  // Identifies the total count of issues that have been opened in the repository.
    var organization: User?
    var owner: User?  // The User owner of the repository.
    var privateField: Bool?
    var pushedAt: String?
    var size: Int?  // The number of kilobytes this repository occupies on disk.
    var sshUrl: String?
    var stargazersCount: Int?  // Identifies the total count of items who have starred this starrable.
    var subscribersCount: Int?  // Identifies the total count of users watching the repository
    var updatedAt: Date?  // Identifies the date and time when the object was last updated.
    var url: String?  // The HTTP URL for this repository
    var watchers: Int?
    var watchersCount: Int?
    var parentFullname: String?  // The parent repository's name with owner, if this is a fork.
    
    var commitsCount: Int?  // Identifies the total count of the commits
    var pullRequestsCount: Int?  // Identifies the total count of a list of pull requests that have been opened in the repository.
    var branchesCount: Int?
    var releasesCount: Int?  // Identifies the total count of releases which are dependent on this repository.
    var contributorsCount: Int?  // Identifies the total count of Users that can be mentioned in the context of the repository.
    
    var viewerHasStarred: Bool?  // Returns a boolean indicating whether the viewing user has starred this starrable.
    
    init?(map: Map) {}
    init() {}
    
    init(name: String?, fullname: String?, description: String?, language: String?, languageColor: String?, stargazers: Int?, viewerHasStarred: Bool?, ownerAvatarUrl: String?) {
        self.name = name
        self.fullname = fullname
        self.descriptionField = description
        self.language = language
        self.languageColor = languageColor
        self.stargazersCount = stargazers
        self.viewerHasStarred = viewerHasStarred
        owner = User()
        owner?.avatarUrl = ownerAvatarUrl
    }
    
    init(repo: TrendingRepository) {
        self.init(name: repo.name, fullname: repo.fullname, description: repo.descriptionField,
                  language: repo.language, languageColor: repo.languageColor, stargazers: repo.stars,
                  viewerHasStarred: nil, ownerAvatarUrl: repo.builtBy?.first?.avatar)
    }
    
    mutating func mapping(map: Map) {
        archived <- map["archived"]
        cloneUrl <- map["clone_url"]
        createdAt <- (map["created_at"], ISO8601DateTransform())
        defaultBranch <- map["default_branch"]
        descriptionField <- map["description"]
        fork <- map["fork"]
        forks <- map["forks"]
        forksCount <- map["forks_count"]
        fullname <- map["full_name"]
        hasDownloads <- map["has_downloads"]
        hasIssues <- map["has_issues"]
        hasPages <- map["has_pages"]
        hasProjects <- map["has_projects"]
        hasWiki <- map["has_wiki"]
        homepage <- map["homepage"]
        htmlUrl <- map["html_url"]
        language <- map["language"]
        license <- map["license"]
        name <- map["name"]
        networkCount <- map["network_count"]
        nodeId <- map["node_id"]
        openIssues <- map["open_issues"]
        openIssuesCount <- map["open_issues_count"]
        organization <- map["organization"]
        owner <- map["owner"]
        privateField <- map["private"]
        pushedAt <- map["pushed_at"]
        size <- map["size"]
        sshUrl <- map["ssh_url"]
        stargazersCount <- map["stargazers_count"]
        subscribersCount <- map["subscribers_count"]
        updatedAt <- (map["updated_at"], ISO8601DateTransform())
        url <- map["url"]
        watchers <- map["watchers"]
        watchersCount <- map["watchers_count"]
        parentFullname <- map["parent.full_name"]
    }
    
    func parentRepository() -> Repository? {
        guard let parentFullName = parentFullname else { return nil }
        var repository = Repository()
        repository.fullname = parentFullName
        return repository
    }
}

