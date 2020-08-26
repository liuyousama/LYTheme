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
    
    private var currentThemeState: ThemeState? = nil
    #warning("使用读写锁代替，LYThemeColorPicker中还需要对Manager进行读取")
    private lazy var lock = NSLock()
    private init(){}
    
    func switchTheme(_ theme: LYTheme, completion: (()->Void)? = nil) {
        guard currentTheme != theme else {return}

        DispatchQueue.global().async { [weak self] in
            guard let `self` = self else {
                fatalError("[LYTheme]:LYThemeManager has been deinited! Please keep your LYThemeManaget in the memory during using it")
            }
            // 因为可能在多个线程中调用switchTheme方法来变更当前的主题数据，所以加锁以确保并发安全
            self.lock.lock()
            defer {self.lock.unlock()}
            // 执行theme状态变更操作，并发出通知
            self._switchThemeState()
            Notification.Name.LYThemeChanged.post()
            // 完成所有任务之后执行completion
            if let completion = completion { completion() }
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
    private enum ThemeState {
        case index(Int)
        case plist([String: Any])
        case dictionary([String: UIColor]?, [String: UIImage]?)
    }
}
