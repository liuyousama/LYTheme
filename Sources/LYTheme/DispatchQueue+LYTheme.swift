//
//  DispatchQueue+LYTheme.swift
//  LYTheme
//
//  Created by 尹清正 on 2020/8/26.
//

import Foundation

extension DispatchQueue {
    static let workQueue = DispatchQueue(
        label: "com.liuyousama.LYTheme.workQueue",
        qos: .default,
        attributes: .concurrent
    )
    
    func barrierAsync(execute: @escaping () -> Void) {
        self.async(qos: .default, flags: .barrier, execute: execute)
    }
}
