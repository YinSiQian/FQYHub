//
//  BaseViewController.swift
//  FQYHub
//
//  Created by ysq on 2019/7/8.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import UIKit


let kScreen_width = UIScreen.main.bounds.width
let kScreen_height = UIScreen.main.bounds.height

class BaseViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = LightTheme().background

    }
    

}
