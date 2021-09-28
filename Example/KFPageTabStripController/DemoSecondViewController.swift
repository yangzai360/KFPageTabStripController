//
//  DemoSecondViewController.swift
//  KFPageTabStripController_Example
//
//  Created by jieyang on 2021/9/16.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import KFPageTabStripController

open class DemoSecondViewController : UIViewController, IndicatorInfoProvider {
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        view.clipsToBounds = true
    }
    
    public func indicatorInfo(for pageTabController: PageTabViewController) -> IndicatorInfo {
        let info = IndicatorInfo(title: "其他")
        return info
    }
}
