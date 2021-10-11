//
//  DemoViewFirstController.swift
//  KFPageTabStripController_Example
//
//  Created by jieyang on 2021/9/16.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import KFPageTabStripController

open class DemoFirstViewController : UIViewController, IndicatorInfoProvider {
    
    private lazy var button :UIButton = { [unowned self] in
        let btn = UIButton()
        btn.setTitle("Enter PageTabDemo", for: .normal)
        btn.backgroundColor = .yellow
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()
    
    var indicatorInfo = IndicatorInfo(title: "服务通知")
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        view.clipsToBounds = true
        
        view.addSubview(button)
        button.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: UIScreen.main.bounds.size.width - 20, height: 200))
        }
    }
    
    public func indicatorInfo(for pageTabController: PageTabViewController) -> IndicatorInfo {
        indicatorInfo.unreadCount = 100
        return indicatorInfo
    }
}
