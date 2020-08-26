//
//  LYTheme+UIView.swift
//  LYTheme
//
//  Created by 尹清正 on 2020/8/26.
//

import UIKit

private var UIView_theme_backgroundColorKey: Void?
extension UIView {
    var theme_backgroundColor: LYThemeColorPicker {
        get {
            return "none"
        }
        set {
            setUpAdaptor(newValue, self, &UIView_theme_backgroundColorKey) { [weak self] color in
                self?.backgroundColor = color
            }
        }
    }
}

private var UIView_theme_tintColorKey: Void?
extension UIView {
    var theme_tintColor: LYThemeColorPicker {
        get {
            return "none"
        }
        set {
            setUpAdaptor(newValue, self, &UIView_theme_tintColorKey) { [weak self] color in
                self?.tintColor = color
            }
        }
    }
}
