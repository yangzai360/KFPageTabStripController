//
//  PageBarButtonCell.swift
//  KFPageTabStripController
//
//  Created by jieyang on 2021/9/17.
//

import Foundation
import SnapKit

class PageBarButtonCell : UICollectionViewCell {
    
    open var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label = UILabel()
        addSubview(label)
        label.snp_makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview()
        }
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    
}
