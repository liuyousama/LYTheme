//
//  LYTheme.swift
//  LYTheme
//
//  Created by 尹清正 on 2020/8/26.
//

import UIKit

public enum LYTheme: Equatable {
    public static func == (lhs: LYTheme, rhs: LYTheme) -> Bool {
        switch (lhs, rhs) {
        case let (.index(i1), .index(i2)):
            return i1 == i2
        case let (.plist(path: path1), .plist(path: path2)):
            return path1 == path2
        default:
            return false
        }
    }
    
    case index(Int)
    case plist(path:String)
    case dictionary([String:UIColor]?, [String:UIImage]?)
}
