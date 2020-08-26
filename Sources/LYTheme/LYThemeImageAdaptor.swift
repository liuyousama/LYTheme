//
//  LYThemeImageAdaptor.swift
//  LYThemeTests
//
//  Created by 尹清正 on 2020/8/26.
//

import UIKit

class LYThemeImageAdaptor {
    private var adaptClosure: (UIImage) -> Void
    private var imagePicker: LYThemeImagePicker
    
    init(_ picker: LYThemeImagePicker, _ closure: @escaping (UIImage) -> Void) {
        self.imagePicker = picker
        self.adaptClosure = closure
        self.adapt()
        self.setupObservers()
    }
    
    private func adapt() {
        DispatchQueue.workQueue.async {
            if let image = imagePicker.pickedImage {
                DispatchQueue.main.sync {[weak self] in
                    self?.adaptClosure(image)
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
