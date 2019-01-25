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

    var date: Date!
    var timeTraveler: TimeTraveler!
    var trial: TrialPeriod!
    
    override func setUp() {
        super.setUp()
        
        date = Date()
        timeTraveler = TimeTraveler(date: date)
        trial = TrialPeriod(dateGenerator: timeTraveler.generateDate)
    }
    
    func testNotesFromDaveDelong() {
        // Be lenient with the date math
        
        let seconds = date.timeIntervalSinceReferenceDate - Date().timeIntervalSinceReferenceDate
        print("Seconds: \(seconds)")
        
        if seconds < 60 {
            print("The times are within 60 seconds")
        }
        
        // Note: this can fail if time crosses the hour boundary with nano seconds
        let isEqual = Calendar.current.isDate(date, equalTo: trial.dateInstalled, toGranularity: .hour)
        print("isEqual: \(isEqual)")
        
        // You might want to expire the date at midnight of the day, rather than the exact nanosecond
        // 7 days later, so a trial might last for 7 days 15 hours
        
        // Making unit tests to capture, and document this behavior is a good exercise from this project
    }
    
    func testTrialPeriodDefaultDateInstalled() {
        XCTAssertEqual(date, trial.dateInstalled)
    }
    
    // DRY: Don't Repeat Yourself
    
    func testDefaultDurationIs7Days() {
        XCTAssertEqual(7, trial.durationInDays)
    }
    
    func testDateExpiredIs7DaysAfterInstallDate() {
        let expected = Calendar.current.date(byAdding: .day, value: 7, to: date)
        
        XCTAssertEqual(expected, trial.dateExpired)
    }
    
    func testNotExpiredOnStart() {
        XCTAssertFalse(trial.isExpired())
    }
    
    func testIsExpiredAfter7Days() {
        timeTraveler.timeTravelBy(days: 7)
        
        XCTAssertTrue(trial.isExpired())
    }
    
}
