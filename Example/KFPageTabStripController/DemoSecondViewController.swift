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
    weak var pageTabViewControllerOp: PageTabViewController?
    var indicatorInfo = IndicatorInfo(title: "其他")
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        view.clipsToBounds = true
        
        indicatorInfo.unreadCount = 88
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            guard (self.pageTabViewControllerOp != nil) else {return}
            self.indicatorInfo.unreadCount = 32
            self.pageTabViewControllerOp!.updateIndicatorInfo(self)
        }
    }
    
    public func indicatorInfo(for pageTabController: PageTabViewController) -> IndicatorInfo {
        pageTabViewControllerOp = pageTabController
        return indicatorInfo
    }
    
}
