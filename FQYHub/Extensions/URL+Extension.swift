//
//  URL+Extension.swift
//  FQYHub
//
//  Created by ysq on 2019/7/9.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import Foundation


// MARK: - Properties
public extension URL {
    
    /// SwifterSwift: Dictionary of the URL's query parameters
    var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false), let queryItems = components.queryItems else { return nil }
        
        var items: [String: String] = [:]
        
        for queryItem in queryItems {
            items[queryItem.name] = queryItem.value
        }
        
        return items
    }
    
}
