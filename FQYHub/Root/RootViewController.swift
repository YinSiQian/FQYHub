//
//  RootViewController.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/7/4.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import UIKit

class RootViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubview()
    }
    
    func setupSubview() {
        
        let trend = TrendingViewController()
        let trendNav = NavigationViewController(rootViewController: trend)
        
        let mine = MineViewController()
        let mineNav = NavigationViewController(rootViewController: mine)
        
        viewControllers = [trendNav, mineNav]
        
        let titles = ["trending", "mine"]
        
        for (index, item) in tabBar.items!.enumerated() {
            item.title = titles[index]
        }
        
    }


}
