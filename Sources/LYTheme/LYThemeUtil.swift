//
//  LYThemeUtil.swift
//  LYTheme
//
//  Created by 六游 on 2020/8/25.
//

import UIKit

struct LYThemeUtil {
    
    /// 从指定的路径中读取对应的plist文件，并将文件中的内容转成字典
    /// - Parameter path: plist文件的路径
    /// - Returns: plist文件中的内容所转化而来的字典
    static func loadPlistDict(path: String) -> [String:Any]? {
        let nsDictOpt = NSDictionary(contentsOfFile: path)
        guard let nsDict = nsDictOpt else {
            print("[LYTheme] Error: Fail to read plist file: \(path), please check the existence or the validity of the file")
            return nil
        }
        guard let dict = nsDict as? Dictionary<String, Any> else {
            print("[Theme] Error: Fail to load plist data, please check the data pattern of you plist file: \(path).")
            return nil
        }
        return dict
    }
    
    /// 将一个表示RGB颜色的十六进制字符串转化为对应的UIColor
    /// - Parameter hex: 表示颜色的十六进制字符串，该字符串由可选的前缀#和十六进制颜色代码组成，颜色代码可以是代表RGB的六位字符串，也可以是代表ARGB的八位字符串。
    /// - Returns: 字符串经过转化生成的UIColor对象，如果参数输入有误或者转换过程出现错误会返回nil
    static func color(withHex hex: String) -> UIColor? {
        let r, g, b, alpha: CGFloat
        let offset = hex.hasPrefix("#") ? 1 : 0
        let start = hex.index(hex.startIndex, offsetBy: offset)
        let hexColor = String(hex[start...])
        guard hexColor.count == 6 || hexColor.count == 8 else {return nil}
        
        let hasAlpha = hexColor.count > 6
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0
        guard scanner.scanHexInt64(&hexNumber) else { return nil }
        
        alpha = hasAlpha
            ?CGFloat((hexNumber&0xff000000) >> 24) / 255
            :1
        r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
        g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
        b = CGFloat(hexNumber & 0x0000ff) / 255
        
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
}
