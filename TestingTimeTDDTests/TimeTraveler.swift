//
//  TimeTraveler.swift
//  TestingTimeDemo1Tests
//
//  Created by Paul Solt on 1/24/19.
//  Copyright © 2019 Paul Solt. All rights reserved.
//

import Foundation

// John Sundell

class TimeTraveler {
    var date: Date
    
    init(date: Date = Date()) {
        self.date = date
    }
    
    func generateDate() -> Date {
        return date
    }
    
    func timeTravelBy(seconds: TimeInterval) {
        date = date.addingTimeInterval(seconds)
    }
    
    func timeTravelBy(days: Int) {
        date = Calendar.current.date(byAdding: .day, value: days, to: date)!
    }
}
