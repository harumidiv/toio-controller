//
//  ToioControllerUITests.swift
//  ToioControllerUITests
//
//  Created by 佐川晴海 on 2019/06/14.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import XCTest

class ToioControllerUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testSnapshot() {
        #if MOCK
            snapshot("connect")
            let app = XCUIApplication()
            app.navigationBars["探索中..."].children(matching: .button).element.tap()
            snapshot("Information")
            Thread.sleep(forTimeInterval: 0.3)
            app.navigationBars["情報"].buttons["探索中..."].tap()
            XCUIApplication().buttons["cubeを探す"].tap()
            snapshot("Controller")
        #endif
    }
}
