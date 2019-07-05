//
//  SegmentControl.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/7/5.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import HMSegmentedControl

class SegmentControl: HMSegmentedControl {
    
    let segmentSelection = BehaviorRelay<Int>(value: 0)
    
    let separatorLine = UIView()
    
    init() {
        super.init(sectionTitles: [])
        config()
    }
    
    override init!(sectionTitles sectiontitles: [String]!) {
        super.init(sectionTitles: sectiontitles)
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        config()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    func config() {
        
        separatorLine.backgroundColor = LightTheme().separator
        addSubview(separatorLine)
        
        separatorLine.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(self)
            make.height.equalTo(1)
        }
        
        titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                               NSAttributedString.Key.foregroundColor: LightTheme().text]
        selectedTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                                       NSAttributedString.Key.foregroundColor: LightTheme().primary]
        selectionIndicatorLocation = .down
        selectionIndicatorHeight = 3
        selectionIndicatorBoxOpacity = 0
        selectionIndicatorColor = LightTheme().primary
        indexChangeBlock = { [weak self] index in
            self?.segmentSelection.accept(index)
        }
        
        
        
        setNeedsDisplay()
    }
    
}
