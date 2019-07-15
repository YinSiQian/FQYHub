//
//  UIViewController+Extension.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/6/27.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

extension UIViewController {
    
    public func show(with message: String) {
        let hud = MBProgressHUD(view: self.view)
        hud.removeFromSuperViewOnHide = true
        hud.mode = .indeterminate
        hud.label.text = message
        self.view.addSubview(hud)
        hud.show(animated: true)
    }
    
    public func showSuc(with message: String) {
        let hud = MBProgressHUD(view: self.view)
        hud.removeFromSuperViewOnHide = true
        hud.mode = .customView
        hud.customView = UIImageView(image: UIImage(named: "Checkmark"))
        hud.label.text = message
        self.view.addSubview(hud)
        hud.show(animated: true)
        hud.hide(animated: true, afterDelay: 2.0)
    }
    
    public func showFail(with message: String) {
        let hud = MBProgressHUD(view: self.view)
        self.view.addSubview(hud)
        hud.removeFromSuperViewOnHide = true
        hud.mode = .customView
        hud.customView = UIImageView(image: UIImage(named: "error"))
        hud.label.text = message
        hud.show(animated: true)
        hud.hide(animated: true, afterDelay: 2.0)
    }
    
    public func hideHUD() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    public func show(message: String) {
        
        let action = UIAlertAction(title: "确定", style: .default) { (_) in
            
        }
        let alert = UIAlertController(title: "Tip", message: message, preferredStyle: .alert)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}
