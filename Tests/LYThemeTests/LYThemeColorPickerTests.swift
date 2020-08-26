//
//  LYThemeColorPickerTests.swift
//  LYThemeTests
//
//  Created by 尹清正 on 2020/8/26.
//

import XCTest
@testable import LYTheme

final class LYThemeColorPickerTests: XCTestCase {
    var expactation: XCTestExpectation!
    
    override func setUp() {
        self.expactation = self.expectation(description: "开始异步测试")
    }
    
    /// 测试颜色选择器从plist文件中读取颜色
    func testPickedColor1() {
        defer {waitForExpectations(timeout: 1, handler: nil)}
        
        let path = Bundle(for: Self.self).path(forResource: "test", ofType: "plist")!
        LYThemeManager.shared.switchTheme(.plist(path: path))
        let picker: LYThemeColorPicker = "Color1"
        DispatchQueue.workQueue.async { [weak self] in
            guard let `self` = self else {XCTFail(); return}
            XCTAssertNotNil(picker.pickedColor)
            XCTAssertEqual(
                picker.pickedColor!,
                UIColor(red: 1, green: 0, blue: 0, alpha: 1),
                "颜色选择器输出颜色应该为不透明红色"
            )
            self.expactation.fulfill()
        }
    }
    
    /// 测试颜色选择器从字典中读取颜色
    func testPickedColor2() {
        defer {waitForExpectations(timeout: 1, handler: nil)}
        
        LYThemeManager.shared.switchTheme(.dictionary(["DictColor1": .red], nil))
        let picker: LYThemeColorPicker = "DictColor1"
        DispatchQueue.workQueue.async { [weak self] in
            guard let `self` = self else {XCTFail(); return}
            XCTAssertNotNil(picker.pickedColor)
            XCTAssertEqual(
                picker.pickedColor!,
                .red,
                "颜色选择器输出颜色应该为UIColor.red"
            )
            self.expactation.fulfill()
        }
    }
    
    /// 测试颜色选择器从UIColor数组中读取颜色
    func testPickedColor3() throws {
        defer {waitForExpectations(timeout: 1, handler: nil)}
        
        LYThemeManager.shared.switchTheme(.index(1))
        let picker: LYThemeColorPicker = [.red, .black]
        DispatchQueue.workQueue.async { [weak self] in
            guard let `self` = self else {XCTFail(); return}
            XCTAssertNotNil(picker.pickedColor)
            XCTAssertEqual(
                picker.pickedColor!,
                .black,
                "颜色选择器输出颜色应该为UIColor.black"
            )
            self.expactation.fulfill()
        }
    }
    
    /// 测试颜色选择器从plist文件中读取颜色，使用嵌套字典的方式
    func testPickedColor4() throws {
        defer {waitForExpectations(timeout: 1, handler: nil)}
        
        let path = Bundle(for: Self.self).path(forResource: "test", ofType: "plist")!
        LYThemeManager.shared.switchTheme(.plist(path: path))
        let picker: LYThemeColorPicker = "Home.Color2"
        DispatchQueue.workQueue.async { [weak self] in
            guard let `self` = self else {XCTFail(); return}
            XCTAssertNotNil(picker.pickedColor)
            XCTAssertEqual(
                picker.pickedColor!,
                UIColor(red: 1, green: 1, blue: 0, alpha: 1),
                "颜色选择器输出颜色与test.plist文件中Home.Color2对应的颜色不同"
            )
            self.expactation.fulfill()
        }
    }
}
