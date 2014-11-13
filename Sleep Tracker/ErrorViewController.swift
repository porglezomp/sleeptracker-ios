//
//  ErrorViewController.swift
//  Sleep Tracker
//
//  Created by Caleb Jones on 11/12/14.
//  Copyright (c) 2014 Caleb Jones. All rights reserved.
//

import UIKit
import HealthKit

class ErrorViewController: UIViewController {
    var delegate: ViewController?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkIfValid", name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkIfValid()
    }
    
    func checkIfValid() {
        if delegate?.healthKitStore?.authorizationStatusForType(delegate?.categoryType) == HKAuthorizationStatus.SharingAuthorized {
            self.performSegueWithIdentifier("returnFromError", sender: self)
        }
    }
}
