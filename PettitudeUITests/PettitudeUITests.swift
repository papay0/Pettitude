//
//  PettitudeUITests.swift
//  PettitudeUITests
//
//  Created by Arthur Papailhau on 23/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

import XCTest

class PettitudeUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = true

        app = XCUIApplication()
        setupSnapshot(app)
        app.launchArguments = ["uitests"]
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_fastlane_Cat() {
        app.launchArguments.append("cat")
        app.launch()
        acceptCameraAccess()
        snapshot("01-Cat")
    }

    func test_fastlane_Dog() {
        app.launchArguments.append("dog")
        app.launch()
        acceptCameraAccess()
        snapshot("02-Dog")
    }

    // MARK: - Private

    private func acceptCameraAccess() {
        let springboardApp = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let alert = springboardApp.alerts.element
        if alert.buttons["OK"].exists {
            alert.buttons["OK"].tap()
        }
    }

}
