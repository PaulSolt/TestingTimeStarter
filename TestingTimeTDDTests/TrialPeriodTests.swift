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

    var date: Date!
    var timeTraveler: TimeTraveler!
    var trial: TrialPeriod!

    override func setUp() {
        super.setUp()
        
        date = Date()
        timeTraveler = TimeTraveler(date: date)
        trial = TrialPeriod(dateGenerator: timeTraveler.generateDate)
    }
    
    // All test functions start with the word "test"
    
    func testTrialPeriodDateInstalledIsToday() {
        XCTAssertEqual(date, trial.dateInstalled)
    }

    func testTrialPeriodDefaultDurationIs7Days() {
        XCTAssertEqual(7, trial.durationInDays)
    }
    
    func testTrialPeriodDateExpiredIs7DaysAfterInstallDate() {
        let expected = Calendar.current.date(byAdding: .day, value: 7, to: date)
        XCTAssertEqual(expected, trial.dateExpired)
    }
    
    func testTrialPeriodNotExpiredOnStart() {
        XCTAssertFalse(trial.isExpired())
    }
    
    func testTrialPeriodExpiredAfter7Days() {
        timeTraveler.timeTravelBy(days: 7)
        
        XCTAssertTrue(trial.isExpired())
    }

    // Test with more confidence (try changing the duration)
    //    func testTrialExpiresAfter21Days()

    // Test new functions like reset()
    //    func testResetChangesDateToCurrentTime()

    // Try the Code Kata Challenges to test time logic
    
}
