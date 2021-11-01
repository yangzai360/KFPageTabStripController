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
    func updateIndicatorView()
}

public protocol PageTabStripDataSource: AnyObject {
    func viewControllers(for pageTabController: PageTabViewController) -> [UIViewController]
}

open class PageTabViewController : UIViewController, UIScrollViewDelegate {
    
    open var scrollView: UIScrollView = {
        var scrollViewAux = UIScrollView(frame: CGRect())
        scrollViewAux.bounces = true
        scrollViewAux.alwaysBounceHorizontal = true
        scrollViewAux.alwaysBounceVertical = false
        scrollViewAux.scrollsToTop = false
        scrollViewAux.showsVerticalScrollIndicator = false
        scrollViewAux.showsHorizontalScrollIndicator = false
        scrollViewAux.isPagingEnabled = true
        scrollViewAux.backgroundColor = .white
        return scrollViewAux
    }()
    
    open var containerView: UIView = {
        let containerViewAux = UIView(frame: CGRect())
        return containerViewAux
    }()
    
    open weak var delegate: PageTabStripDelegate?
    open weak var datasource: PageTabStripDataSource?
    
    open private(set) var viewControllers = [UIViewController]()
    open private(set) var currentIndex = 0
    
    open var pageWidth: CGFloat {
        return view.bounds.width
    }
    open func pageOffsetForChild(at index: Int) -> CGFloat {
        return CGFloat(index) * pageWidth
    }
    open func offsetForChild(at index: Int) -> CGFloat {
        return CGFloat(index) * pageWidth
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.snp_makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalToSuperview().offset(50)
        }
        scrollView.addSubview(containerView)
        containerView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
        reloadDataSource()
        installChildViewController()
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: 0)
    }
    
    private func reloadDataSource() {
        guard let dataSource = datasource else {
            print("datasource is nil!")
            return
        }
        viewControllers = dataSource.viewControllers(for: self)
        guard !viewControllers.isEmpty else {
            print("viewControllers is nil!")
            return
        }
        viewControllers.forEach { vc in
            if !(vc is IndicatorInfoProvider) {
                print("one of viewControllers not confirm IndicatorInfoProvider!")
                return
            }
        }
    }
    
    func installChildViewController() {
        for (index, childController) in viewControllers.enumerated() {
            addChild(childController)
            containerView.addSubview(childController.view)
            childController.view.snp_makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.left.equalToSuperview().offset(CGFloat(index) * pageWidth)
                make.width.equalTo(pageWidth)
                if index == self.viewControllers.count - 1 {
                    make.right.equalToSuperview()
                }
            }
        }
    }
    
    // MARK: - Public
    open func updateIndicatorInfo(_ viewController: UIViewController) {
        assertionFailure("Sub-class must implement the PagerTabStripDataSource viewControllers(for:) method")
    }
    
    // MARK: - PagerTabStripDataSource
    open func viewControllers(for pageTabController: PageTabViewController) -> [UIViewController] {
        assertionFailure("Sub-class must implement the PagerTabStripDataSource viewControllers(for:) method")
        return []
    }
    
    // MARK: - UISCrollViewDelegate
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y != 0 {
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0.0)
        }
        
        let rate = scrollView.contentOffset.x / pageWidth
        let newIndex = (Int)(rate + 0.5)
        if newIndex > viewControllers.count - 1 || newIndex < 0 {
            return
        }
        delegate?.updateIndicatorView()
        if currentIndex != newIndex {
            currentIndex = newIndex
        }
    }
}
