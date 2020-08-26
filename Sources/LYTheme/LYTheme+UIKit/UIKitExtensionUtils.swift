//
//  UIKitExtensionUtils.swift
//  LYTheme
//
//  Created by 尹清正 on 2020/8/26.
//


import UIKit

func setUpAdaptor(
    _ picker: LYThemeColorPicker,
    _ obj: Any,
    _ key: UnsafeRawPointer,
    closure: @escaping (UIColor) -> Void)
{
    let adaptor = LYThemeColorAdaptor(picker, closure)
    objc_setAssociatedObject(obj, key, adaptor, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
}
