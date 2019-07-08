//
//  RepositoryDetailController.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/7/5.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import UIKit

class RepositoryDetailController: BaseViewController {

    var fullName: String = "" {
        didSet {
            title = fullName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    


}
