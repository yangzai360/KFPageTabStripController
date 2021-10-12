//
//  PageBarButtonCell.swift
//  KFPageTabStripController
//
//  Created by jieyang on 2021/9/17.
//

import Foundation
import SnapKit
import UIKit

class PageBarButtonCell : UICollectionViewCell {
    
    let unselectedFont = UIFont.init(name: "PingFang-SC-Redular", size: 13) ?? UIFont.systemFont(ofSize: 13)
    let unselectedColor = UIColor.gray
    let selectedFont = UIFont.init(name: "PingFang-SC-Medium", size: 16) ?? UIFont.boldSystemFont(ofSize: 16)
    let selectedColor = UIColor.black
    
    open lazy var label : UILabel = {
        let labelAux = UILabel()
        labelAux.textAlignment = .center
        labelAux.font = selectedFont
        labelAux.textColor = selectedColor
        return labelAux
    }()
    
    var unreadDot = UnreadRedDot(frame: CGRect())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.snp_makeConstraints { make in
            make.left.right.equalToSuperview().priorityLow()
            make.centerX.equalToSuperview().priorityHigh()
            make.height.equalTo(25)
            make.top.equalToSuperview().offset(7)
            make.bottom.equalToSuperview().offset(-13)
        }
        addSubview(unreadDot)
        unreadDot.snp_makeConstraints { make in
            make.left.equalTo(label.snp_right).offset(-12)
            make.bottom.equalTo(label.snp_top).offset(10)
        }
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open func changeToUnselected() {
        label.font = unselectedFont
        label.textColor = unselectedColor
    }
    open func changeToSelected() {
        label.font = selectedFont
        label.textColor = selectedColor
    }
}
