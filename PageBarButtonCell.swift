//
//  PageBarButtonCell.swift
//  KFPageTabStripController
//
//  Created by jieyang on 2021/9/17.
//

import Foundation
import SnapKit

class PageBarButtonCell : UICollectionViewCell {
    
    open var label : UILabel = {
        let labelAux = UILabel()
        labelAux.textAlignment = .center
        return labelAux
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.snp_makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    
}
