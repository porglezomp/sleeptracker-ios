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
    var endTimeAsleep: NSDate? { get }
}

class ReviewSleepViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var minutesField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var minutes: Int {
        get {
            if minutesField.text.toInt() != nil {
                return minutesField.text.toInt()!
            }
            return 0
        }}
    
    var delegate: SleepReviewResponder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func submitMinutes(sender: AnyObject) {
        // Add the estimated time to fall asleep to the time the button was pressed
        delegate.startTimeAsleep = delegate.startTimeAsleep?.dateByAddingTimeInterval(NSTimeInterval(minutes) * 60.0)
        if delegate.startTimeAsleep?.timeIntervalSince1970 > delegate.endTimeAsleep?.timeIntervalSince1970 {
            // If it goes too far, clip it to the end time so we don't get an error
            delegate.startTimeAsleep = delegate?.endTimeAsleep
        }
        self.performSegueWithIdentifier("returnFromSleepReview", sender: self)
    }
}
