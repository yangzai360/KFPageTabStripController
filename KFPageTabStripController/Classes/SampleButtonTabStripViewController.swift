//
//  SampleButtonTabStripViewController.swift
//  KFPageTabStripController
//
//  Created by jieyang on 2021/9/15.
//

import UIKit
import SnapKit

public struct KFSampleButtonPageTabSettings {
    public struct Style {
        public var containerViewBackgroundColor = UIColor.white
        public var buttonBarBackgroundColor = UIColor.white
        public var indicatorViewBackgroundColor = UIColor(red: 0x7F/256, green: 0x00/256, blue: 0xFF/256, alpha: 1)
        public var indicatorHeight: CGFloat = 3
        
        public var buttonBarItemBackgroundColor: UIColor?
        public var buttonBarItemLeftRightMargin: CGFloat = 8
        public var buttonBarHeight: CGFloat = 45
        public var defaultShowPageIndex = 0
    }
    public var style = Style()
}

open class SampleButtonTabStripViewController : PageTabViewController, PageTabStripDataSource, PageTabStripDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    public var setting = KFSampleButtonPageTabSettings()
    
    private var viewIsLoaded = false
    
    public var pageTabCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 20
        flowLayout.estimatedItemSize = CGSize(width: 100, height: 45) // cell内部自己维护 KF的高度需要固定45
        flowLayout.sectionInset = UIEdgeInsets(top: 7, left: 20, bottom: 0, right: 0)
        flowLayout.scrollDirection = .vertical
        let collectionViewAux = UICollectionView(frame: CGRect(x: 0, y: 0,
                                                               width: UIScreen.main.bounds.size.width, height: 30),
                                                 collectionViewLayout: flowLayout)
        collectionViewAux.isScrollEnabled = false
        return collectionViewAux
    }()
    
    public var selectedTabIndicatorView: UIView = {
        let barViewAux = UIView()
        barViewAux.layer.zPosition = 9999
        return barViewAux
    }()
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        delegate = self
        datasource = self
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        delegate = self
        datasource = self
    }
    
    // MARK: - Life cycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.backgroundColor = setting.style.containerViewBackgroundColor
                
        view.addSubview(pageTabCollectionView)
        pageTabCollectionView.snp_makeConstraints { make in
            make.top.left.right.equalTo(view)
            make.height.equalTo(50)
        }
        pageTabCollectionView.delegate = self
        pageTabCollectionView.dataSource = self
        pageTabCollectionView.backgroundColor = setting.style.buttonBarBackgroundColor
        pageTabCollectionView.register(PageBarButtonCell.self, forCellWithReuseIdentifier:"KFPageBarButtonCell")

        selectedTabIndicatorView.layer.cornerRadius = setting.style.indicatorHeight / 2
        selectedTabIndicatorView.backgroundColor = setting.style.indicatorViewBackgroundColor
        pageTabCollectionView.addSubview(selectedTabIndicatorView)
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !viewIsLoaded && setting.style.defaultShowPageIndex <= viewControllers.count {
            scrollView.setContentOffset(CGPoint(x: pageWidth * CGFloat(setting.style.defaultShowPageIndex),
                                                y: 0),
                                        animated: false)
        }
        viewIsLoaded = true
        updateIndicatorView()
    }
    
    // MARK: - PageTabStrip
    override open func updateIndicatorInfo(_ viewController: UIViewController) {
        if viewControllers.contains(viewController) {
            let index = viewControllers.firstIndex(of: viewController)!
            pageTabCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
            updateIndicatorView()
        }
    }
    
    // MARK: - PageTabStripDelegate
    public func updateIndicatorView() {
        
        let rate = scrollView.contentOffset.x / pageWidth
        let toIndex = (Int)(rate + 0.5)
        
        guard shouldUpdateButtonBarView, viewIsLoaded == true else { return }
        let preIndex = Int(floor(rate))
        let nextIndex = preIndex + 1
        var preCellFrameOp = pageTabCollectionView.cellForItem(at: IndexPath(row: preIndex, section: 0))?.frame
        var nextCellFrameOp = pageTabCollectionView.cellForItem(at: IndexPath(row: nextIndex, section: 0))?.frame
        if preCellFrameOp == nil && nextCellFrameOp != nil {
            preCellFrameOp = nextCellFrameOp!.offsetBy(dx: -nextCellFrameOp!.size.width, dy: 0)
        }
        if nextCellFrameOp == nil && preCellFrameOp != nil {
            nextCellFrameOp = preCellFrameOp!.offsetBy(dx: preCellFrameOp!.size.width, dy: 0)
        }
        
        guard let preFrame = preCellFrameOp, let nextFrame = nextCellFrameOp else {
            //如果使劲儿接力滑动，可能出现
            return
        }
        
        // 目前进度条在前后偏移的百分比，起点左边就是 99%
        let percent = rate - CGFloat(preIndex)
        let newPositionX = preFrame.origin.x + (nextFrame.origin.x - preFrame.origin.x) * percent
        let newWidth = preFrame.size.width + (nextFrame.size.width - preFrame.size.width) * percent
        // Move indicator bar view
        selectedTabIndicatorView.frame = CGRect(x: newPositionX,
                                                y: 42,
                                                width: newWidth,
                                                height: setting.style.indicatorHeight)
        
        // 更新样式
        let toCellOp = pageTabCollectionView.cellForItem(at: IndexPath(row: toIndex, section: 0))
        guard let toCellOp = toCellOp else { return }
        let toCell = toCellOp as! PageBarButtonCell
        toCell.changeToSelected()
        if (currentIndex != toIndex) {
            let fromCellOp = pageTabCollectionView.cellForItem(at: IndexPath(row: currentIndex, section: 0))
            guard let fromCellOp = fromCellOp else { return }
            let fromCell = fromCellOp as! PageBarButtonCell
            fromCell.changeToUnselected()
        }
    }
    
    // MARK: - UICollectionView DataSource
    // rows number
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewControllers.count
    }
    
    // cell for item at IndexPath
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KFPageBarButtonCell", for: indexPath) as? PageBarButtonCell else {
            fatalError("UICollectionViewCell should be or extend from ButtonBarViewCell")
        }
        
        let childController = viewControllers[indexPath.row] as! IndicatorInfoProvider
        let indicatorInfo = childController.indicatorInfo(for: self)

        cell.setText(indicatorInfo.title)
        cell.unreadDot.setUnreadCount(indicatorInfo.unreadCount)
        if indexPath.row == currentIndex {
            cell.changeToSelected()
        } else {
            cell.changeToUnselected()
        }
        return cell
    }
    
    // MARK: - UICollectionView Delegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        scrollView.setContentOffset(CGPoint(x: pageWidth * CGFloat(indexPath.row),
                                            y: 0),
                                    animated: true)
    }
    
    // MARK: - Pricate
    private var shouldUpdateButtonBarView = true
    private var collectionViewDidLoad = false
}
