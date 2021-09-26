//
//  IndicatorInfo.swift
//  KFPageTabStripController
//
//  Created by jieyang on 2021/9/15.
//

import Foundation

public struct IndicatorInfo {
    public var title: String?
    public var image: UIImage?
    public var highlightedImage: UIImage?
    public var accessibilityLabel: String?
    public var userInfo: Any?
    
    public init(title: String?) {
        self.title = title
        self.accessibilityLabel = title
    }
}
