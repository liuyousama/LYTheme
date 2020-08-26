//
//  Notification+LYTheme.swift
//  LYTheme
//
//  Created by 尹清正 on 2020/8/26.
//

import Foundation

extension Notification.Name {
    static let LYThemeChanged = Notification.Name("LYTheme.changed")
}

extension Notification.Name {
    func post(_ object: Any? = nil, _ userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: self, object: object, userInfo: userInfo)
    }
    
    func observe(
        _ object: Any? = nil,
        _ queue: OperationQueue? = nil,
        _ using: @escaping (Notification) -> Void
    ) {
        NotificationCenter.default.addObserver(forName: self, object: object, queue: queue, using: using)
    }
}
