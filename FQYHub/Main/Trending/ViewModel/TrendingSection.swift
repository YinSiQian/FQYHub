//
//  TrendingSection.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/7/5.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import Foundation
import RxDataSources

enum TrendingSection {
    case repositories(items: [TrendingSectionItem])
    case users(items: [TrendingSectionItem])
}

public enum TrendingSectionItem {
    case trendingRepositoriesItem(viewModel: TrendingRepositoryCellViewModel)
    case trendingUserItem(viewModel: TrendingUserCellViewModel)
}

extension TrendingSection: SectionModelType {
    init(original: TrendingSection, items: [TrendingSectionItem]) {
        switch original {
            case .repositories(let items): self = .repositories(items: items)
            case .users(let items): self = .users(items: items)
        }
    }
    
    
    typealias Item = TrendingSectionItem
    
    var title: String {
        switch self {
        case .repositories(_): return "trending"
        case .users(_): return "trending"
        }
    }
    
    var items: [TrendingSectionItem] {
        switch self {
            case .repositories(let items): return items.map { $0}
            case .users(let items): return items.map { $0}
        }
    }

    
}


