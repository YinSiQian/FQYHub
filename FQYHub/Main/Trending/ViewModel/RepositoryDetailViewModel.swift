//
//  RepositoryDetailViewModel.swift
//  FQYHub
//
//  Created by ysq on 2019/7/5.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import Foundation
import RxSwift

class RepositoryDetailViewModel: NSObject {
    
    var repo = Observable<Repository>.of()
    
    init(with fullName: String) {
        
        repo = singleProvider.repository(fullname: fullName).asObservable()
        
    }
}
