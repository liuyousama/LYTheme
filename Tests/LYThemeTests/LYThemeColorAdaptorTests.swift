//
//  LYThemeColorAdaptorTests.swift
//  LYThemeTests
//
//  Created by 尹清正 on 2020/8/26.
//

import XCTest
@testable import LYTheme

final class LYThemeColorAdaptorTests: XCTestCase {
    var expactation: XCTestExpectation!
    
    override func setUp() {
        self.expactation = self.expectation(description: "开始异步测试")
    }
    
    func testUIViewBgColor() {
        defer{waitForExpectations(timeout: 1, handler: nil)}
        
        LYThemeManager.shared.switchTheme(.index(0), completion: nil)
        let view = UIView()
        view.theme_backgroundColor = [.red, .black]
        
        LYThemeManager.shared.switchTheme(.index(1)) {
            XCTAssertNotNil(view.backgroundColor)
            XCTAssertEqual(
                view.backgroundColor!,
                .black
            )
            LYThemeManager.shared.switchTheme(.index(0)) {
                XCTAssertNotNil(view.backgroundColor)
                XCTAssertEqual(
                    view.backgroundColor!,
                    .red
                )
                self.expactation.fulfill()
            }
        }
    }
    
}
