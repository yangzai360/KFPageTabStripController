//
//  PagerTabStripViewController.swift
//  KFPageTabStripController
//
//  Created by jieyang on 2021/9/15.
//

import Foundation
import SnapKit

public protocol IndicatorInfoProvider {
    func indicatorInfo(for pageTabController: PageTabViewController) -> IndicatorInfo
}

public protocol PageTabStripDelegate: AnyObject {
    func updateIndicator(for viewController: PageTabViewController, fromIndex: Int, toIndex: Int)
}

public protocol PageTabStripDataSource: AnyObject {
    func viewControllers(for pageTabController: PageTabViewController) -> [UIViewController]
}

open class PageTabViewController : UIViewController, UIScrollViewDelegate {
    
    public var containerView: UIScrollView!

    open weak var delegate: PageTabStripDelegate?
    open weak var datasource: PageTabStripDataSource?
    
    open private(set) var viewControllers = [UIViewController]()
    open private(set) var currentIndex = 0

    open var pageWidth: CGFloat {
        return containerView.bounds.width
    }
    open func pageOffsetForChild(at index: Int) -> CGFloat {
        return CGFloat(index) * containerView.bounds.width
    }
    open func offsetForChild(at index: Int) -> CGFloat {
        return CGFloat(index) * containerView.bounds.width
//        + ((containerView.bounds.width - view.bounds.width) * 0.5
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        containerView = UIScrollView()
        view.addSubview(containerView)
        containerView.snp_makeConstraints { make in
            make.edges.equalTo(view)
        }
        containerView.bounces = true
        containerView.alwaysBounceHorizontal = true
        containerView.alwaysBounceVertical = false
        containerView.scrollsToTop = false
        containerView.delegate = self
        containerView.showsVerticalScrollIndicator = false
        containerView.showsHorizontalScrollIndicator = false
        containerView.isPagingEnabled = true
        containerView.backgroundColor = .yellow
        reloadDataSource()
        installChildViewController()
        view.clipsToBounds = true
        print(containerView.frame.size)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        containerView.contentSize = CGSize(width: containerView.bounds.width * CGFloat(viewControllers.count), height: view.bounds.height)
    }
    
    private func reloadDataSource() {
        guard let dataSource = datasource else {
            print("datasource is nil!")
            return;
        }
        viewControllers = dataSource.viewControllers(for: self)
        guard !viewControllers.isEmpty else {
            print("viewControllers is nil!")
            return;
        }
        viewControllers.forEach { vc in
            if !(vc is IndicatorInfoProvider) {
                print("one of viewControllers not confirm IndicatorInfoProvider!")
                return;
            }
        }
    }
    
    func installChildViewController() {
        for (index, childController) in viewControllers.enumerated() {
//            let pageOffsetForChild = self.pageOffsetForChild(at: index)
            addChild(childController)
            childController.view.frame = CGRect(x: CGFloat(index) * view.bounds.width,
                                                y: 0,
                                                width: view.bounds.width,
                                                height: view.bounds.height)
//            childController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            containerView.addSubview(childController.view)
        }
        containerView.contentSize = CGSize(width: view.bounds.width * CGFloat(viewControllers.count), height: view.bounds.height)
    }
    
    // MARK: - PagerTabStripDataSource
    open func viewControllers(for pageTabController: PageTabViewController) -> [UIViewController] {
        assertionFailure("Sub-class must implement the PagerTabStripDataSource viewControllers(for:) method")
        return []
    }
}
