//
//  LYThemeManager.swift
//  LYTheme
//
//  Created by 尹清正 on 2020/8/26.
//

import UIKit

public class LYThemeManager {
    public static var shared = LYThemeManager()
    public var currentTheme: LYTheme? = nil
    
    var currentThemeState: ThemeState? = nil
    private lazy var lock = NSLock()
    private init(){}
    
    public func switchTheme(_ theme: LYTheme, completion: (()->Void)? = nil) {
        guard currentTheme != theme else {return}
        
        /// 异步地向workQueue（串行队列）中提交一项任务
        DispatchQueue.workQueue.async { [weak self] in
            guard let `self` = self else {
                fatalError("[LYTheme]:LYThemeManager has been deinited! Please keep your LYThemeManager in the memory during using it")
            }
            // 执行theme状态变更操作，并发出通知
            self.currentTheme = theme
            self._switchThemeState()
            // 由于通知是同步的，所以发送通知会在此向workQueue中提交一系列的 颜色/图片 更新任务
            Notification.Name.LYThemeChanged.post()
            // 将completion的执行作为一个任务提交给workQueue，此时该任务在队列的最末尾
            // 只有当此次主题变动所产生的 颜色/图片 更新任务全部执行完毕才会调用completion
            DispatchQueue.workQueue.async {
                DispatchQueue.main.sync{completion?()}
            }
        }
    }
    
    private func _switchThemeState() {
        switch currentTheme {
        case .index(let index):
            currentThemeState = .index(index)
        case .plist(let path):
            let dictOpt = LYThemeUtil.loadPlistDict(path: path)
            guard let dict = dictOpt else {return}
            self.currentThemeState = .plist(dict)
        case .dictionary(let colorDict, let imageDict):
            currentThemeState = .dictionary(colorDict, imageDict)
        case .none:
            break
        }
    }
}

extension LYThemeManager {
    enum ThemeState {
        case index(Int)
        case plist([String: Any])
        case dictionary([String: UIColor]?, [String: UIImage]?)
    }
}
