#  Testing Time TDD

An exploration into test driven development with dependency injection.

## Design and Exploration

Test driven development follows design and exploration. If you don't know how to use the APIs, you need to explore before you can design the high level direction.

I've already done that work for this example, you'll be building a starting point for trial period logic. That you can leverage in your app to ask a user to purchase, or to inform them when the trial expires.

    let trial = TrialPeriod()

    if trial.isExpired() {
        showPurchaseDialog()
    } else {
        showTrialDialogWithExpiration(trial.dateExpired)
    }

This system needs to save and load data to disk, so that when the app is closed, it can still remember when the app was first installed. That's beyond the scope of this talk, but you can extend it afterwards.

## Class Interface 

    class TrialPeriod {

        var dateInstalled: Date

        var durationInDays: Int

        var dateExpired: Date { get }

        func isExpired() -> Bool

        func resetTrial()
    }

## Logic Tests

In Xcode you want to run unit tests fast, and by default, unit tests have to start the app, which allows you to test UIKit related logic.

You can disable this behavior, by editing your Unit Test target's General properties.

1. Project Properties > General > Targets > TestingTimeTDD > General
2. Set "Host Application" to None

## 3 Laws of TDD

Uncle Bob's 3 Laws of TDD

1. You must write a failing test before you write any production code.
2. You must not write more of a test than is sufficient to fail, or fail to compile.
3. You must not write more production code than is sufficient to make the currently failing test pass.

## Red Green Refactor

1. **Red**: Create a unit tests that fails.
2. **Green**: Write production code that makes that test pass.
3. **Refactor**: Clean up the mess you just made.

## One Failing Test

You should only have one test failing at a time, and you should not refactor when tests are failing.

If one of your tests cannot pass because you need to refactor, comment out the test, cleanup the logic, make sure the previous tests pass, and then make changes to fix the new test pass.

## Arrange Act Assert (AAA)

Generally your tests should have one assertion, however for clarity you may want to add more to help the reader understand what's being tested.

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

As you refactor, you can simply tests down to less lines of code by leveraging the setUp() method.

Using this model as a guide helps you structure tests that are easy to read.
