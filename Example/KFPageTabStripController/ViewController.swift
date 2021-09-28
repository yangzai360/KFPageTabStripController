//
//  ViewController.swift
//  KFPageTabStripController
//
//  Created by 7035329 on 09/07/2021.
//  Copyright (c) 2021 7035329. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private lazy var button :UIButton = { [unowned self] in
        let btn = UIButton()
        btn.setTitle("Enter PageTabDemo", for: .normal)
        btn.backgroundColor = .yellow
        btn.addTarget(self, action: #selector(enterBtnClicked(btn:)), for: .touchUpInside)
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            let barApp = UINavigationBarAppearance()
            barApp.backgroundColor = .white
            navigationController!.navigationBar.scrollEdgeAppearance = barApp
            navigationController!.navigationBar.standardAppearance = barApp
        }
        
        navigationController?.navigationBar.isTranslucent = false
        view.addSubview(button)
        button.snp_makeConstraints { make in
            make.top.equalTo(view.snp_top).offset(20)
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize(width: UIScreen.main.bounds.size.width - 20, height: 200))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        enterBtnClicked(btn: button)
    }
    
    @objc func enterBtnClicked(btn:UIButton) {
        let messageVC = KFMessageBoxViewController()
        self.navigationController!.pushViewController(messageVC, animated: true)
    }

}

