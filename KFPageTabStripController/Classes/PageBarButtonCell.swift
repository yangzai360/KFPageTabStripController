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
    
    private lazy var label : UILabel = {
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
            make.left.right.equalToSuperview()
            make.width.greaterThanOrEqualTo(0)
            make.centerX.equalToSuperview()
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
    
    open func setText(_ text: String?) {
        label.text = text ?? ""
        let width = NSString(string: label.text!).boundingRect(with: CGSize(width: 999, height: 999),
                                                         options: .usesLineFragmentOrigin,
                                                         attributes: [.font: selectedFont],
                                                         context: nil).size.width
        label.snp_updateConstraints { make in
            make.width.greaterThanOrEqualTo(width)
        }
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
