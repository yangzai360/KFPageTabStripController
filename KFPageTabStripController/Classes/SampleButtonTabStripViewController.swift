
import UIKit
import SnapKit

public struct KFSampleButtonPageTabSettings {
    public struct Style {
        public var buttonBarBackgroundColor: UIColor?
        public var selectedBarBackgroundColor = UIColor.black
        public var selectedBarHeight: CGFloat = 5
        
        public var buttonBarItemBackgroundColor: UIColor?
        public var buttonBarItemFont = UIFont.systemFont(ofSize: 18)
        public var buttonBarItemLeftRightMargin: CGFloat = 8
        public var buttonBarItemTitleColor: UIColor?
        
        public var buttonBarHeight: CGFloat?
    }
}

open class SampleButtonTabStripViewController : PageTabViewController, PageTabStripDataSource, PageTabStripDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    public var setting = KFSampleButtonPageTabSettings()
    
    public var pageTabCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 20
        flowLayout.estimatedItemSize = CGSize(width: 100, height: 25) // cell内部自己维护 KF的高度需要固定25
        flowLayout.sectionInset = UIEdgeInsets(top: 7, left: 20, bottom: 0, right: 0)
        
        flowLayout.scrollDirection = .vertical
        let collectionViewAux = UICollectionView(frame: CGRect(x: 0, y: 0,
                                                               width: UIScreen.main.bounds.size.width, height: 30),
                                                 collectionViewLayout: flowLayout)
//      debug color
        //        collectionViewAux.backgroundColor = UIColor.red
        
        return collectionViewAux
    }()
    
    public var selectedTabIndicatorView: UIView = {
       let barViewAux = UIView(frame: CGRect(x: 20, y: 42, width: 64, height: 3))
        barViewAux.layer.cornerRadius = 1.5 // 这个值需要在外部改变的时候动态变成 height/2
        barViewAux.backgroundColor = .purple
        barViewAux.backgroundColor = UIColor(red: 0x7F/256, green: 0x00/256, blue: 0xFF/256, alpha: 1)
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
        if pageTabCollectionView.superview == nil {
            view.addSubview(pageTabCollectionView)
            pageTabCollectionView.snp_makeConstraints { make in
                make.top.left.right.equalTo(view)
                make.height.equalTo(50)
            }
        }
        if pageTabCollectionView.delegate == nil {
            pageTabCollectionView.delegate = self
        }
        if pageTabCollectionView.dataSource == nil {
            pageTabCollectionView.dataSource = self
        }
        
        if selectedTabIndicatorView.superview == nil {
            pageTabCollectionView.addSubview(selectedTabIndicatorView)
        }
        
        pageTabCollectionView.register(PageBarButtonCell.self, forCellWithReuseIdentifier:"KFPageBarButtonCell")
    }

    
    // MARK: - PageTabStripDelegate
    public func updateIndicator(for viewController: PageTabViewController, fromIndex: Int, toIndex: Int, rate: CGFloat) {
        guard shouldUpdateButtonBarView else { return }
        let preIndex = Int(floor(rate))
        let nextIndex = preIndex + 1
        var preCellFrameOp = pageTabCollectionView.cellForItem(at: IndexPath(row: preIndex, section: 0))?.frame
        var nextCellFrameOp = pageTabCollectionView.cellForItem(at: IndexPath(row: nextIndex, section: 0))?.frame
        if preCellFrameOp == nil {
            preCellFrameOp = nextCellFrameOp!.offsetBy(dx: -nextCellFrameOp!.size.width, dy: 0)
        }
        if nextCellFrameOp == nil {
            nextCellFrameOp = preCellFrameOp!.offsetBy(dx: preCellFrameOp!.size.width, dy: 0)
        }
        
        guard let preFrame = preCellFrameOp, let nextFrame = nextCellFrameOp else {
            //如果使劲儿接力滑动，可能真的出现这种情况
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
                                                height: 3)
        
        // 更新样式
        let toCellOp = pageTabCollectionView.cellForItem(at: IndexPath(row: toIndex, section: 0))
        guard let toCellOp = toCellOp else { return }
        let toCell = toCellOp as! PageBarButtonCell
        toCell.changeToSelected()
        if (fromIndex != toIndex) {
            let fromCellOp = pageTabCollectionView.cellForItem(at: IndexPath(row: fromIndex, section: 0))
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
        cell.label.text = indicatorInfo.title
        if indexPath.row == currentIndex {
            cell.changeToSelected()
        } else {
            cell.changeToUnselected()
        }
        return cell
    }
    
    // MARK: - Pricate
    private var shouldUpdateButtonBarView = true
    private var collectionViewDidLoad = false
}
