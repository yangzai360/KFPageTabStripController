//
//  IndicatorInfo.swift
//  KFPageTabStripController
//
//  Created by jieyang on 2021/9/15.
//

import Foundation

public struct IndicatorInfo {
    public var title: String?
    public var unreadCount = 0
    
    public init(title: String?) {
        self.title = title
    }
}
