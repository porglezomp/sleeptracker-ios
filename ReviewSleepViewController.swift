//
//  File.swift
//  Sleep Tracker
//
//  Created by Caleb Jones on 11/12/14.
//  Copyright (c) 2014 Caleb Jones. All rights reserved.
//

import UIKit

protocol SleepReviewResponder {
    var startTimeAsleep: NSDate? { get set }
}

class ReviewSleepViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var minutesField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var minutes: Int32 = 0
    
    var delegate: SleepReviewResponder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func submitMinutes(sender: AnyObject) {
        // Add the estimated time to fall asleep to the time the button was pressed
        delegate.startTimeAsleep = delegate.startTimeAsleep?.dateByAddingTimeInterval(NSTimeInterval(minutes) * 60.0)
        self.performSegueWithIdentifier("returnFromSleepReview", sender: self)
    }
}
