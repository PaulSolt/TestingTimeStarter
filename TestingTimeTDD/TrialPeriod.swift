//
//  TimeTrial.swift
//  TestingTimeTDD
//
//  Created by Paul Solt on 1/25/19.
//  Copyright © 2019 Paul Solt. All rights reserved.
//

import Foundation

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
    
    init(dateGenerator: @escaping DateGenerator = Date.init) {
        dateInstalled = dateGenerator() //Date()
        self.dateGenerator = dateGenerator
        self.durationInDays = TrialPeriod.defaultDuration
    }
    
    func isExpired() -> Bool {
        let currentDate = dateGenerator()
        if currentDate >= dateExpired {
            return true
        }
        return false
    }
}
