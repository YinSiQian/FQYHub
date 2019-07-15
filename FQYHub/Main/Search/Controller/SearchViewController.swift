//
//  SearchViewController.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/7/5.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        singleProvider.searchUsers(query: "dvi", page: 1).asObservable().subscribe(onNext: { (model) in
            
            print("items  ---->\(model.items)")
            
        }).disposed(by: disposeBag)
        
    }
    

    

}
