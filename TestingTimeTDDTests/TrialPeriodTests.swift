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

typealias DateGenerator = () -> Date

class TrialPeriod {
    var dateInstalled: Date
    var dateGenerator: DateGenerator
    
    init(dateGenerator: @escaping DateGenerator) {
        self.dateInstalled = dateGenerator()
        self.dateGenerator = dateGenerator
    }
}

class TrialPeriodTests: XCTestCase {

    // All test functions start with the word "test"

    func testTrialPeriod() {
        // Arrange
        let expected = Date()
        let timeTraveler = TimeTraveler(date: expected)
        let trial = TrialPeriod(dateGenerator: timeTraveler.generateDate)
        
        // Act
        let actualDate = trial.dateInstalled
        
        print("Expected: \(expected.timeIntervalSinceReferenceDate)")
        print("Actual: \(actualDate.timeIntervalSinceReferenceDate)")
        
        // Assert
        XCTAssertEqual(expected, actualDate)
    }
}
