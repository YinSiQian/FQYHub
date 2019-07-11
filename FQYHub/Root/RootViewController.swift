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
        
        let search = SearchViewController()
        let searchNav = NavigationViewController(rootViewController: search)
        
        let mine = MineViewController()
        mine.title = "Me"
        let mineNav = NavigationViewController(rootViewController: mine)
        
        viewControllers = [trendNav, searchNav, mineNav]
        let titles = ["Trending", "Search", "Me"]
        let selectedImages = [#imageLiteral(resourceName: "icon_trending_selected"), #imageLiteral(resourceName: "icon_search_selected"), #imageLiteral(resourceName: "icon_mine_selected")]
        let images = [#imageLiteral(resourceName: "icon_trending_normal"), #imageLiteral(resourceName: "icon_search_normal"), #imageLiteral(resourceName: "icon_mine_normal")]

        
        for (index, item) in tabBar.items!.enumerated() {
            item.title = titles[index]
            item.selectedImage = selectedImages[index]
            item.image = images[index]
        }
        
    }


}
