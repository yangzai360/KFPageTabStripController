//
//  KFMesageBoxViewController.swift
//  KFPageTabStripController_Example
//
//  Created by jieyang on 2021/9/7.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import SnapKit
import KFPageTabStripController

open class KFMessageBoxViewController : SampleButtonTabStripViewController {
    
    public override func viewControllers(for pageTabController: PageTabViewController) -> [UIViewController] {
        
        let firstVC = DemoFirstViewController()
        let secondVC = DemoSecondViewController()
        return [firstVC, secondVC];
    }
}
