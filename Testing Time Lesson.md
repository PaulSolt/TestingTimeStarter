# Testing Time Code Lesson

## 1. Test Trial Period

	func testTrialPeriod() {
	    let trial = TrialPeriod()
	}

Compiler error is a failure (red)

	class TrialPeriod {
	}

## 2. Arrange Act Assert

	func testTrialPeriod() {
	    // Arrange
	    let trial = TrialPeriod()
	    let expected = Date()
	    
	    // Act
	    let actual = trial.dateInstalled
	    
	    // Assert
	    XCTAssertEqual(expected, actual)
	}


## 3. Make It Pass

	class TrialPeriod {
	    var dateInstalled: Date
	    
	    init() {
	        dateInstalled = Date()
	    }
	}

## 4. It Fails Why? Print Dates

    func testTrialPeriod() {
        // Arrange
        let trial = TrialPeriod()
        let expected = Date()
        
        // Act
        let actual = trial.dateInstalled
        
        print("Expected: \(expected.timeIntervalSinceReferenceDate)")
        print("Actual: \(actual.timeIntervalSinceReferenceDate)")
        
        // Assert
        XCTAssertEqual(expected, actual)
    }

output

Expected: 570126870.167193
Actual: 570126870.167146

## 5. Use the Time Traveler

Create a typealias

	typealias DateGenerator = () -> Date

Store a reference to the date generator

typealias DateGenerator = () -> Date

	class TrialPeriod {
	    var dateInstalled: Date
	    var dateGenerator: DateGenerator
	    
	    init(dateGenerator: @escaping DateGenerator) {
	        dateInstalled = Date()
	        self.dateGenerator = dateGenerator
	    }
	}

Use the dateGenerator to create the date

    dateInstalled = Date()

becomes

    dateInstalled = dateGenerator()

## 6. Test Passes


	typealias DateGenerator = () -> Date
	
	class TrialPeriod {
	    var dateInstalled: Date
	    var dateGenerator: DateGenerator
	    
	    init(dateGenerator: @escaping DateGenerator) {
	        dateInstalled = dateGenerator()
	        self.dateGenerator = dateGenerator
	    }
	}

Test function

	func testTrialPeriod() {
	    // Arrange
	    let expected = Date()
	    let timeTraveler = TimeTraveler(date: expected)
	    let trial = TrialPeriod(dateGenerator: timeTraveler.generateDate)
	    
	    // Act
	    let actual = trial.dateInstalled
	    
	    print("Expected: \(expected.timeIntervalSinceReferenceDate)")
	    print("Actual: \(actual.timeIntervalSinceReferenceDate)")
	    
	    // Assert
	    XCTAssertEqual(expected, actual)
	}

Cleanup and remove print statements

## 7. testDefaultDurationIs7Days()

	func testDefaultDurationIs7Days() {
	    let expected = 7
	    let trial = TrialPeriod()
	    
	    let actual = trial.durationInDays
	    
	    XCTAssertEqual(expected, actual)
	}


But we can't create TrialPeriod without TimeTraveler ... so we create a time traveler and notice repeated code.

func testDefaultDurationIs7Days() {
    let expected = 7
    let trial = TrialPeriod(dateGenerator: timeTraveler.generateDate)
    
    let actual = trial.durationInDays
    
    XCTAssertEqual(expected, actual)
}


## 8. Add the Stub and Initialize It


	class TrialPeriod {
	    var dateInstalled: Date
	    var dateGenerator: DateGenerator
	    var durationInDays: Int
	    
	    init(dateGenerator: @escaping DateGenerator) {
	        dateInstalled = dateGenerator()
	        self.dateGenerator = dateGenerator
	        self.durationInDays = 0
	    }
	}

Set it to 0, so that it fails

Run the test, see the red

Fix it to 7

Run the test, see the green

## 9. Refactor the Magic Number

Add a static (public) value

    static let defaultDuration = 7

Use the new constant

    self.durationInDays = TrialPeriod.defaultDuration

Run the test, and verify it still passes

## 10. Too much redundant code (DRY: Don't Repeat Yourself)

Copy from 2nd test

    var date: Date!
    var timeTraveler: TimeTraveler!
    var trial: TrialPeriod!

setUp runs for every unit test, so that we always start with a fresh set of objects.

    override func setUp() {
        super.setUp()
        
        date = Date()
        timeTraveler = TimeTraveler(date: date)
        trial = TrialPeriod(dateGenerator: timeTraveler.generateDate)
    }

Collapse the method

    func testDefaultDurationIs7Days() {        
        XCTAssertEqual(7, trial.durationInDays)
    }

Previous test had too much noise, and can be more concise.

Fix the first test

    func testTrialPeriod() {
        XCTAssertEqual(date, trial.dateInstalled)
    }

## 11. Test Expired Date

	func testDateExpiredIs7DaysAfterInstallDate() {
	}

Write test (optional return type)

	func testDateExpiredIs7DaysAfterInstallDate() {
	    let expected = Calendar.current.date(byAdding: .day, value: 7, to: date)!
	    
	    XCTAssertEqual(expected, trial.dateExpired)
	}

 Implement logic as a computed property

    var dateExpired: Date {
        return Calendar.current.date(byAdding: .day, value: durationInDays, to: dateInstalled)!
    }

## 13: (Optional) Refactor and Extract Into a Date Extension

	extension Date {
	    func addingDays(_ days: Int) -> Date {
	        return Calendar.current.date(byAdding: .day, value: days, to: self)!
	    }
	}

Refactor method

	var dateExpired: Date {
	    return dateInstalled.addingDays(durationInDays)
	}

## 14 Too Much Code, Let's Extract to a Class

Move `class TrialPeriod` to TrialPeriod.swift

Build and run, verify unit tests still pass (add to unit test target if it fails to find symbols)

## 15. Test Trial Is Not Expired on Start

	func testNotExpiredOnStart() {
        XCTAssertFalse(trial.isExpired())
	}

Implement logic as a function

	func isExpired() -> Bool {
	    return true
	}

## 16. Test After 7 Days 


    func testExpiredAfter7Days() {
        timeTraveler.timeTravelBy(days: 7)
        
        XCTAssertTrue(trial.isExpired())
    }

Implement the logic

    func isExpired() -> Bool {
        let currentDate = dateGenerator()
        if currentDate >= dateExpired {
            return true
        }
        return false
    }

## 17. Uncomment trialPeriod in ViewController

    let trial = TrialPeriod()

and

        if trial.isExpired() {
            showPurchaseDialog()
        } else {
            showTrialDialogWithExpiration(trial.dateExpired)
        }

Fix dateGenerator to use date.init

    init(dateGenerator: @escaping DateGenerator = Date.init) {
        dateInstalled = dateGenerator()
        self.dateGenerator = dateGenerator
        self.durationInDays = TrialPeriod.defaultDuration
    }


## 18. Test With More Confidence

Test changing the duration, and verifying it expires when we expect.

Caught several bugs when I was writing this the second time with tests, that I had in my prototype code.

    func testTrialExpiresAfter21Days()

Add a new method

    func resetTrial()

And test it with the timeTraveler

    func testResetChangesDateToCurrentTime()