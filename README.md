#  Testing Time TDD

An exploration into test driven development.

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

