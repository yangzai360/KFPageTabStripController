
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
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30);//section之间的间距
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(width: 100, height: 30)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        flowLayout.scrollDirection = .horizontal
        let collectionViewAux = UICollectionView(frame: CGRect(x: 0, y: 0,
                                                               width: UIScreen.main.bounds.size.width, height: 30),
                                                 collectionViewLayout: flowLayout)
        collectionViewAux.backgroundColor = UIColor.red
        
        return collectionViewAux
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
                make.height.equalTo(30)
            }        }
        if pageTabCollectionView.delegate == nil {
            pageTabCollectionView.delegate = self
        }
        if pageTabCollectionView.dataSource == nil {
            pageTabCollectionView.dataSource = self
        }
        
        pageTabCollectionView.register(PageBarButtonCell.self, forCellWithReuseIdentifier:"KFPageBarButtonCell")

        
    }

    
    // MARK: - PageTabStripDelegate
    open func updateIndicator(for viewController: PageTabViewController, fromIndex: Int, toIndex: Int) {
        guard shouldUpdateButtonBarView else { return }
    }
    
    // MARK: - UICollectionView DataSource
    
    // rows number
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewControllers.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KFPageBarButtonCell", for: indexPath) as? PageBarButtonCell else {
            fatalError("UICollectionViewCell should be or extend from ButtonBarViewCell")
        }
        
        let childController = viewControllers[indexPath.row] as! IndicatorInfoProvider
        let indicatorInfo = childController.indicatorInfo(for: self)
        cell.label.text = indicatorInfo.title
        
        cell.backgroundColor = UIColor.purple
        return cell
    }
    
    // MARK: - Pricate
    private var shouldUpdateButtonBarView = true
    private var collectionViewDidLoad = false
}
