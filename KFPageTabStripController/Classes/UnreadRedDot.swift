//
//  UnreadRedDot.swift
//  KFPageTabStripController
//
//  Created by jieyang on 2021/10/8.
//

import UIKit

class UnreadRedDot : UIView {
    open lazy var label : UILabel = {
        let labelAux = UILabel()
        labelAux.textAlignment = .center
        labelAux.font = .systemFont(ofSize: 12)
        labelAux.textColor = .clear
        return labelAux
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 8
        layer.masksToBounds = true
        addSubview(label)
        label.snp_makeConstraints { make in
            make.top.left.bottom.right.equalToSuperview()
            make.center.equalToSuperview()
            make.width.equalTo(35)
            make.height.equalTo(16)
        }
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open func setUnreadCount(_ count: Int) {
        var width = 35, height = 16
        if count <= 0 {
            label.text = ""
            label.textColor = .clear
            self.backgroundColor = .clear
            width = 0
            height = 0
        } else if count > 99 {
            label.text = "99+"
            label.textColor = .white
            self.backgroundColor = .red
            width = 35
        } else {
            label.text = String(count)
            label.textColor = .white
            self.backgroundColor = .red
            width = 25
        }
        label.snp_updateConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(height)
        }
    }
}
