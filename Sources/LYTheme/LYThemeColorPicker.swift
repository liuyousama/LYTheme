//
//  LYThemeColorPicker.swift
//  LYTheme
//
//  Created by 尹清正 on 2020/8/26.
//

import UIKit

struct LYThemeColorPicker: ExpressibleByArrayLiteral,
                        ExpressibleByStringLiteral{
    /// 当前颜色选择器的选择类型。表明该颜色选择器选择颜色的方式，有字符键和数组索引两种方式
    private var pickedType: PickedType
    /// 可以使用字符串字面量的方式初始化
    public init(stringLiteral value: String) {
        pickedType = .keyed(value)
    }
    /// 可以使用数组字面量的方式初始化
    public init(arrayLiteral elements: UIColor...) {
        pickedType = .indexed(elements)
    }
    
    /// 使用颜色数组来初始化一个主题颜色选择器
    /// - Parameter colors: UIColor数组
    init(colors: [UIColor]) {
        pickedType = .indexed(colors)
    }
    
    /// 获取到当前选择器在对应主题中拿到的颜色
    var pickedColor: UIColor? {
        let currentState = LYThemeManager.shared.currentThemeState
        switch (currentState, pickedType) {
        case (nil, _):
            print("[LYTheme] Warning: Can't get a color.You haven't set a exact theme to the theme manager")
            return nil
        case let (.index(index), .indexed(colorsArray)):
            return _pickColorByArray(array: colorsArray, index: index)
        case let (.plist(dict), .keyed(key)):
            return _pickColorByPlist(dict: dict, key: key)
        case let (.dictionary(colorDict, _), .keyed(key)):
            return _pickColorByDictionary(dict: colorDict, key: key)
        default:
            print("[LYTheme] Warning: Cant get a color. Index theme must match a theme_color which is inited by a UIColors' array, and Plist and Dictionary theme must match a theme_color which is inited by a string. There is a dismatch now.")
            return nil
        }
    }
    
    /// 根据颜色选择器的键，在plist文件转化来的字典中查找一个颜色
    /// - Parameters:
    ///   - dict: plist文件转化而来的字典
    ///   - key: 颜色选择器的键
    /// - Returns: 查找到的颜色
    private func _pickColorByPlist(dict:[String: Any], key: String) -> UIColor? {
        let keys = key.split(separator: ".").map { subString in
            String(subString).trimmingCharacters(in: .whitespaces)
        }
        // 1. 获取以点号分割的最后一个键
        guard let lastKey = keys.last else {
            print("[LYTheme] Warning: Can't get a color. You provided a empty key string")
            return nil
        }
        // 2. 解决字典的嵌套
        var dictTmp = dict
        for k in keys.dropLast() {
            guard let newDict = dictTmp[k] as? [String:Any] else {
                print("[LYTheme] Warning: Can't get a color. LYTheme can not find a color item with the key: [\(key)] in the plist file you privided")
                return nil
            }
            dictTmp = newDict
        }
        // 3. 从字典中取出颜色的hex字符串
        guard let hexStr = dictTmp[lastKey] as? String else {
            print("[LYTheme] Warning: Can't get a color. LYTheme can not find a color item with the key: [\(key)] in the plist file you privided")
            return nil
        }
        // 4. 使用hex字符串初始化一个UIColor
        guard let color = LYThemeUtil.color(withHex: hexStr) else {
            print("[LYTheme] Warning: Can't get a color. LYTheme can not parse the hex string: [\(hexStr)] into a UIColor. Please check the pattern of your hex string")
            return nil
        }
        return color
    }
    
    /// 根据当前主题的数组索引值，在颜色选择器的颜色数组中查找一个颜色
    /// - Parameters:
    ///   - array: 颜色选择器的颜色数组
    ///   - index: 当前主题的数组索引值
    /// - Returns: 查找到的颜色
    private func _pickColorByArray(array:[UIColor], index:Int) -> UIColor? {
        guard index < array.count else {
            print("[LYTheme] Warning: Can't get a color. The index [\(index)] which you set to the theme is out of range of the UIColor's array: \(array)")
            return nil
        }

        return array[index]
    }
    
    /// 根据颜色选择器的键，在当前主题提供的字典数据中查找到一个颜色
    /// - Parameters:
    ///   - dict: 当前主题的字典数据
    ///   - key: 颜色选择器的键
    /// - Returns: 查找到的颜色
    private func _pickColorByDictionary(dict:[String: UIColor]?, key:String) -> UIColor? {
        guard let dict = dict else {
            print("[LYTheme]: Warning: Can't get a color. You provided an empty UIColor's dictionary")
            return nil
        }
        guard let color = dict[key] else {
            print("[LYTheme] Warning: Can't get a color. The dictionary you provided to the theme does not have a key named [\(key)]")
            return nil
        }
        return color
    }
}

extension LYThemeColorPicker {
    private enum PickedType {
        case keyed(String)
        case indexed([UIColor])
    }
}
