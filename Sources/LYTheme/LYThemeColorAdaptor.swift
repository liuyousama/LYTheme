//
//  LYThemeColorAdaptor.swift
//  LYTheme
//
//  Created by 尹清正 on 2020/8/26.
//

import UIKit

class LYThemeColorAdaptor {
    private var adaptClosure: (UIColor) -> Void
    private var colorPicker: LYThemeColorPicker
    
    init(_ picker: LYThemeColorPicker, _ closure: @escaping (UIColor) -> Void) {
        self.colorPicker = picker
        self.adaptClosure = closure
        self.adapt()
        self.setupObservers()
    }
    
    /// 向workQueue中添加一项更新颜色的任务
    private func adapt() {
        DispatchQueue.workQueue.async { [weak self] in
            guard let `self` = self else { return }
            
            if let color = self.colorPicker.pickedColor {
                DispatchQueue.main.sync {[weak self] in
                    self?.adaptClosure(color)
                }
            }
        }
    }
    
    private func setupObservers() {
        Notification.Name.LYThemeChanged.observe { [weak self] _ in
            self?.adapt()
        }
    }
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        self.removeObservers()
    }
}
