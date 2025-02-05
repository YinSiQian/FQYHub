//
//  Configs.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/6/27.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import Foundation
import UIKit

enum Keys {
    case github, jpush
    
    var apiKey: String {
        switch self {
        case .github:
            return "4a0d00e3996c4184885386a9436a7ec5449ee29f"
        case .jpush:
            return "5e950c61a5c6535540015feb"
    
        }
    }
    
    var appId: String {
        switch self {
        case .github:
            return "29d8a2b588b27508858b"
        case .jpush:
            return "6b719ed00832455d47c0f7d5"
        }
    }
}

struct Configs {
    
    struct BaseDimensions {
        static let inset: CGFloat = 15
        static let safeTop: CGFloat = UIApplication.shared.statusBarFrame.height + 44
        static let buttonHeight: CGFloat = 44
        static let cornerRadius: CGFloat = 6
        static let borderWidth: CGFloat = 1
        static let segmentHeight: CGFloat = 44
        static let tableRowHeight = 44
        static let space: CGFloat = 10
    }
    
    struct DefaultSetting {
        static let placeholderImage = UIImage(named: "github")
    }
    
    struct Network {
        static let githubBaseURL = "https://api.github.com/"
        static let trendingBaseURL = "https://github-trending-api.now.sh/"
    }
    
    struct PageHelper {
        static let rows = 30
    }
    
    struct Develope {
        
        static let devStatus = true
        static let clearUserData = false
    }
    
    struct UserDefaultsKeys {
        static let user = "user"
    }
    
    
}
