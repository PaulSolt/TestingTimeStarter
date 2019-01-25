//
//  ViewController.swift
//  TestingTimeTDD
//
//  Created by Paul Solt on 1/25/19.
//  Copyright © 2019 Paul Solt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let trial = TrialPeriod()

    override func viewDidLoad() {
        super.viewDidLoad()
            
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Demo
//        showTrialDialogWithExpiration(Date())
        
        if trial.isExpired() {
            showPurchaseDialog()
        } else {
            showTrialDialogWithExpiration(trial.dateExpired)
        }

    }

    func showPurchaseDialog() {
        print("Trial expired, please upgrade...")
        // TODO: Show upgrade page
    }
    
    func showTrialDialogWithExpiration(_ date: Date) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let dateExpired = formatter.string(from: date)
        let message = "Trial expires on \(dateExpired)."
        
        showExpirationAlert(title: "Trial Period",
                            message: message)
    }
    
    func showExpirationAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: .default,
                                      handler: { (action) in
            print("Ok pressed")
        }))
        alert.addAction(UIAlertAction(title: "Upgrade Today",
                                      style: .default,
                                      handler: { (action) in
            print("Upgrade Today pressed")
            // TODO: Show upgrade page
        }))

        self.present(alert, animated: true)
    }
}

