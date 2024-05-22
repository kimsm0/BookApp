//
//  XCTest+Ex.swift
//  AssignmentUITests
//
//  Created by kimsoomin_mac2022 on 5/5/24.
//

import XCTest

extension XCTestCase {
   
  //element가 화면에 노출
  func isDisplayed(_ value: Any) -> Bool {
        switch value {
        // 텍스트
        case is String:
            guard let text = value as? String else { return false }
            if XCUIApplication().staticTexts[text].waitForExistence(timeout: 4.0) {
                return true
            } else {
                return false
            }
        // UI
        case is XCUIElement:
            guard let element = value as? XCUIElement else { return false }
            if element.waitForExistence(timeout: 4.0) {
                return true
            } else {
                return false
            }
        default:
            return false
        }
    }
}
