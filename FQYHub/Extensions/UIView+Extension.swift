//
//  UIView+Extension.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/6/27.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

extension UIView {
    
    var top: CGFloat {
        return frame.minY
    }
    
    var bottom: CGFloat {
        return frame.maxY
    }
    
    var left: CGFloat {
        return frame.minX
    }
    
    var right: CGFloat {
        return frame.maxX
    }
    
    var width: CGFloat {
        return frame.width
    }
    
    var height: CGFloat {
        return frame.height
    }
    
    public func show(with message: String) {
        let hud = MBProgressHUD(view: self)
        self.addSubview(hud)
        hud.removeFromSuperViewOnHide = true
        hud.mode = .indeterminate
        hud.label.text = message
        hud.show(animated: true)

    }
    
    public func showSuc(with message: String) {
        let hud = MBProgressHUD(view: self)
        self.addSubview(hud)
        hud.removeFromSuperViewOnHide = true
        hud.mode = .customView
        hud.customView = UIImageView(image: UIImage(named: "Checkmark"))
        hud.label.text = message
        hud.show(animated: true)
        hud.hide(animated: true, afterDelay: 2.0)
    }
    
    public func showFail(with message: String) {
        let hud = MBProgressHUD(view: self)
        self.addSubview(hud)
        hud.removeFromSuperViewOnHide = true
        hud.mode = .customView
        hud.customView = UIImageView(image: UIImage(named: "error"))
        hud.label.text = message
        hud.label.numberOfLines = 3
        hud.show(animated: true)
        hud.hide(animated: true, afterDelay: 2.0)
    }
    
    public func hideHUD() {
        MBProgressHUD.hide(for: self, animated: true)
    }
    
}
