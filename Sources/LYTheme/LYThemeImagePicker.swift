//
//  LYThemeImagePicker.swift
//  LYTheme
//
//  Created by 尹清正 on 2020/8/26.
//

import UIKit

struct LYThemeImagePicker: ExpressibleByArrayLiteral,
                        ExpressibleByStringLiteral{
    private var pickedType: PickedType
    
    init(stringLiteral value: String) {
        pickedType = .keyed(value)
    }
    
    init(arrayLiteral elements: UIImage...) {
        pickedType = .indexed(elements)
    }
    
    
    var pickedImage: UIImage? {
        let currentState = LYThemeManager.shared.currentThemeState
        switch (currentState, pickedType) {
        case (nil, _):
            print("[LYTheme] Warning: Can't get a image.You haven't set a exact theme to the theme manager")
            return nil
        case let (.index(index), .indexed(colorsArray)):
            return _pickColorByArray(array: colorsArray, index: index)
        case let (.plist(dict), .keyed(key)):
            return _pickColorByPlist(dict: dict, key: key)
        case let (.dictionary(_, imageDict), .keyed(key)):
            return _pickColorByDictionary(dict: imageDict, key: key)
        default:
            print("[LYTheme] Warning: Cant get a image. Index theme must match a theme_image which is inited by a UIImage' array, and Plist and Dictionary theme must match a theme_image which is inited by a string. There is a dismatch now.")
            return nil
        }
    }
    
    private func _pickColorByPlist(dict:[String: Any], key: String) -> UIImage? {
        let keys = key.split(separator: ".").map { subString in
            String(subString).trimmingCharacters(in: .whitespaces)
        }
        // 1. 获取以点号分割的最后一个键
        guard let lastKey = keys.last else {
            print("[LYTheme] Warning: Can't get a image. You provided a empty key string")
            return nil
        }
        // 2. 解决字典的嵌套
        var dictTmp = dict
        for k in keys.dropLast() {
            guard let newDict = dictTmp[k] as? [String:Any] else {
                print("[LYTheme] Warning: Can't get a image. LYTheme can not find a image item with the key: [\(key)] in the plist file you privided")
                return nil
            }
            dictTmp = newDict
        }
        // 3. 从字典中取出图片名
        guard let imageName = dictTmp[lastKey] as? String else {
            print("[LYTheme] Warning: Can't get a image. LYTheme can not find a image item with the key: [\(key)] in the plist file you privided")
            return nil
        }
        // 4. 加载UIImage
        guard let image = UIImage(named: imageName) else {
            print("[LYTheme] Warning: Can't get a image. Failed to load a image with the image name [\(imageName)] from your bundle")
            return nil
        }
        
        return image
    }
    
    private func _pickColorByArray(array:[UIImage], index:Int) -> UIImage? {
        guard index < array.count else {
            print("[LYTheme] Warning: Can't get a image. The index [\(index)] which you set to the theme is out of range of the UIImage's array: \(array)")
            return nil
        }

        return array[index]
    }
    
    private func _pickColorByDictionary(dict:[String: UIImage]?, key:String) -> UIImage? {
        guard let dict = dict else {
            print("[LYTheme]: Warning: Can't get a image. You provided an empty UIImage's dictionary")
            return nil
        }
        guard let image = dict[key] else {
            print("[LYTheme] Warning: Can't get a image. The dictionary you provided to the theme does not have a key named [\(key)]")
            return nil
        }
        return image
    }
}

extension LYThemeImagePicker {
    private enum PickedType {
        case keyed(String)
        case indexed([UIImage])
    }
}
