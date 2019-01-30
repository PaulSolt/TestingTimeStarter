//
//  TrialPeriodTests.swift
//  TestingTimeTDDTests
//
//  Created by Paul Solt on 1/25/19.
//  Copyright © 2019 Paul Solt. All rights reserved.
//

import XCTest

// Test code in your main module when dynamically linking unit tests
//@testable import TestingTimeTDD



class TrialPeriodTests: XCTestCase {

    // All test functions start with the word "test"

    func testArrangeActAssert() {
        // Arrange
        let x = 20
        let y = 40
        let expected = 60
        
        // Act
        let actual = x + y
        
        // Assert
        XCTAssertEqual(expected, actual)
    }
}
