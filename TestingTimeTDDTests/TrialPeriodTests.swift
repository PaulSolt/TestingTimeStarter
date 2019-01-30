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
    static let defaultDuration = 7
    
    var dateInstalled: Date
    var dateGenerator: DateGenerator
    var durationInDays: Int
    var dateExpired: Date {
        return Calendar.current.date(byAdding: .day,
                                     value: TrialPeriod.defaultDuration,
                                     to: dateInstalled)!
    }
    
    
    init(dateGenerator: @escaping DateGenerator) {
        self.dateInstalled = dateGenerator()
        self.dateGenerator = dateGenerator
        self.durationInDays = TrialPeriod.defaultDuration
    }
}

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

    func testDefaultDurationIs7Days() {
        XCTAssertEqual(7, trial.durationInDays)
    }
    
    func testDateExpiredIs7DaysAfterInstallDate() {
        let expected = Calendar.current.date(byAdding: .day, value: 7, to: date)
        XCTAssertEqual(expected, trial.dateExpired)
    }
    
}
