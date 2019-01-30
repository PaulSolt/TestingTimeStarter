# Testing Time Code Lesson

This lesson will guide you through the steps required to do Test Driven Development with date logic.

It uses [dependency injection](https://en.wikipedia.org/wiki/Dependency_injection), so that you can literally time travel and test your app in the future. This allows you to make your tests very fast, since you won't have to wait days to test the core logic — you can test in milliseconds. 

Use this exercise as a Code Kata to practice dependency injection, and dealing with date logic.

You can extend the tests to include support for more features as well.

* Try the [Bowling Game Kata in Swift or Objective-C](https://qualitycoding.org/tdd-kata/), based on [Uncle Bob's Java based Code Kata](http://butunclebob.com/ArticleS.UncleBob.TheBowlingGameKata).
* Read [John Sundell's post on time traveling](https://www.swiftbysundell.com/posts/time-traveling-in-swift-unit-tests) to get more insight into how it works.

Time to start, the steps that I take in the video will mirror the code steps below. Try and follow along with the video, and then try it again without looking. 

## Fast Tests

For fast tests you'll want to disable "Host Application" testing in your Unit Test Properties.

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

Date is very precise and differs by nanoseconds.

When you test exact times in tests, you either need to provide the exact same Date object, or you need to write code that's more robust with respect to time.

You might consider Date objects within 1 second, or within 60 seconds to be equivalent. 

## 5. Use the Time Traveler

Create a typealias, to make the intent clear. You could also call this a `Clock`.

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

Add `@escaping` to the `dataGenerator` parameter, since the stored function can execute after the scope of the init method.

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


But we can't create `TrialPeriod` without `TimeTraveler`, which needs to get a `Date` object.

	func testDefaultDurationIs7Days() {
	    let expected = 7
	    let date = Date()
	    let timeTraveler = TimeTraveler(date: date)
	    let trial = TrialPeriod(dateGenerator: timeTraveler.generateDate)
	    
	    let actual = trial.durationInDays
	    
	    XCTAssertEqual(expected, actual)
	}

... so we create a time traveler and notice the repeated code between our first two tests. 

After the test passes, you'll want to clean it up so that you don't repeat yourself.

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

1. Set it to `0`, so that it fails
2. Run the test, see the red
3. Fix it to `7`
4. Run the test, see the green

## 9. Refactor the Magic Number

Add a static (public) value

    static let defaultDuration = 7

Use the new constant

    self.durationInDays = TrialPeriod.defaultDuration

Run the test, and verify it still passes

## 10. Too much redundant code (DRY: Don't Repeat Yourself)

Extract the repeated three lines of logic from the 2nd test.

You'll leverage the `setUp()` method to clear the slate for each test, so that they can run independently.

At the top of the Test class add these lines (Copy from 2nd test).

    var date: Date!
    var timeTraveler: TimeTraveler!
    var trial: TrialPeriod!

The `setUp()` method runs for every unit test, so that we always start with a fresh set of objects.

    override func setUp() {
        super.setUp()
        
        date = Date()
        timeTraveler = TimeTraveler(date: date)
        trial = TrialPeriod(dateGenerator: timeTraveler.generateDate)
    }

Refactor and collapse the 2nd test method

    func testDefaultDurationIs7Days() {        
        XCTAssertEqual(7, trial.durationInDays)
    }

The previous test had too much noise that got in the way of the actual test., and can be more concise.

Now refactor and fix the first test, and make sure the test name is meaningful.

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

1. Create a new code file called TrialPeriod.swift

2. Move `class TrialPeriod` to TrialPeriod.swift

3. Build and run, verify unit tests still pass (add to unit test target if it fails to find symbols)

4. For logic tests (Host Application unchecked), make sure to add all source files to your Unit Test Target

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

Uncomment the line in ViewController.swift

    let trial = TrialPeriod()

Uncomment the trial methods, and make the trial dialog use the `trial.dateExpired`.

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


## Congrats!

You've created your first unit test for testing time, and you've learned some of the thought process behind test driven development.

It takes practice to learn how to test production code, but the more you practice, the easier it will be to see how to write testable code.

## Try It Again

Try doing the exercise following the lesson without looking, just refer to the `TimePeriod` interface.

If you need more practice with the Date APIs or Unit Tests, create a sample project to play.

Practice writing the `TimeTraveler` class from scratch, and step through the code using a debugger to see how it works.

## Challenges

Extend the project by adding more functionality and tests to make sure it works.

If you don't know how to use these APIs, try the code in a sample project or playground.

### 1. Challenge: Test With More Confidence

Test changing the duration, and verifying it expires when we expect.

Caught several bugs when I was writing this the second time with tests, that I had in my prototype code.

    func testTrialExpiresAfter21Days()


### 2. Challenge: Add a resetTrial() method

Make the trial period reset to the current day.

    func resetTrial()

And test it with the timeTraveler

    func testResetChangesDateToCurrentTime()

### 3. Make the Trial Expire at Midnight 

Make the trial period expire at midnight Local Time on the 7th Day.

Update any previous tests so that this new logic works as expected.

### 4. Save and Load Time

Add support to save and load time.

1. Save the time using `Codable` to disk in the app's "Documents" directory on iOS.

2. Reload time on init().

3. Write test code to verify your cleanup code worked using `FileManager`

4. Cleanup any files created during the test in the tearDown() method

		override func tearDown() { 
			super.tearDown()
			// Remove files
		}

