//
//  LYThemeUtilTests.swift
//  LYThemeTests
//
//  Created by 六游 on 2020/8/25.
//

import XCTest
@testable import LYTheme

final class LYThemeUtilTests: XCTestCase {
    
    func testLoadPlistDict() throws {
        let path = Bundle(for: Self.self).path(forResource: "test", ofType: "plist")!
        let dictOpt = LYThemeUtil.loadPlistDict(path: path)
        let dict = try XCTUnwrap(dictOpt)
        let color1 = try XCTUnwrap(dict["Color1"] as? String)
        XCTAssertEqual(color1, "#FF0000")
    }
    
    func testColor() throws {
        // 1. 加上#号前缀
        let redOpt = LYThemeUtil.color(withHex: "#FF0000")
        let red = try XCTUnwrap(redOpt, "这里不应该返回为nil")
        XCTAssertEqual(
            red,
            UIColor(red: 1, green: 0, blue: 0, alpha: 1),
            "颜色返回错误"
        )
        // 2. 不加#号前缀
        let randomOpt = LYThemeUtil.color(withHex: "#FFB400")
        let random = try XCTUnwrap(randomOpt, "这里不应该返回为nil")
        XCTAssertEqual(
            random,
            UIColor(red: 1, green: 180/255, blue: 0, alpha: 1),
            "颜色返回错误"
        )
        // 3. 加上透明度
        let alphaOpt = LYThemeUtil.color(withHex: "#A0FFC0CB")
        let alpha = try XCTUnwrap(alphaOpt, "这里不应该返回为nil")
        XCTAssertEqual(
            alpha,
            UIColor(red: 1, green: 192/255, blue: 203/255, alpha: 160/255),
            "颜色返回错误"
        )
        // 4. 提供错误参数
        let wrongColor = LYThemeUtil.color(withHex: "#A789A3789A")
        XCTAssertNil(wrongColor, "这里应该返回nil")
    }
    
}
