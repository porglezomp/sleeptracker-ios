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

class ReviewSleepViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var submitButton: UIBarButtonItem!
    @IBOutlet weak var discardButton: UIBarButtonItem!
    @IBOutlet weak var picker: UIPickerView!
    
    // How quickly did you fall asleep?
    let names = [
        "Instantly (0 minutes)",
        "Very fast (5 minutes)",
        "Fast (10 minutes)",
        "Somewhat fast (20 minutes",
        "Not very fast (30 minutes)",
        "Slow (45 minutes)",
        "Super slow (1 hour)",
        "Ugh (1 hour 20 minutes)",
        "Uuuuugh (1 hour 40 minutes)",
        "GUUUUUH (2 hours)",
    ]
    // Number of minutes corresponding to each choice
    let values = [0, 5, 10, 20, 30, 45, 60, 80, 100, 120]
    
    // Current number selected, also default
    var minutes: Int = 20
    
    var delegate: SleepReviewResponder!
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return names.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return names[row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        minutes = values[row]
        println("\(minutes)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.selectRow(3, inComponent: 0, animated: false)
    }
    
    @IBAction func submitMinutes(sender: AnyObject) {
        // Add the estimated time to fall asleep to the time the button was pressed
        delegate.startTimeAsleep = delegate.startTimeAsleep?.dateByAddingTimeInterval(NSTimeInterval(minutes) * 60.0)
        if delegate.startTimeAsleep?.timeIntervalSince1970 > delegate.endTimeAsleep?.timeIntervalSince1970 {
            // If it goes too far, clip it to the end time so we don't get an error
            delegate.startTimeAsleep = delegate?.endTimeAsleep
        }
        println("\(minutes)")
        self.performSegueWithIdentifier("returnFromSleepReview", sender: self)
    }
    
    @IBAction func discardReview(sender: AnyObject) {
        var alertController = UIAlertController(title: nil, message: "Are you sure you want to discard this? It will delete the current data.", preferredStyle: UIAlertControllerStyle.ActionSheet)
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action: UIAlertAction!) -> Void in }
        var discardAction = UIAlertAction(title: "Discard", style: UIAlertActionStyle.Destructive) { (action: UIAlertAction!) -> Void in
            self.performSegueWithIdentifier("discardSleepReview", sender: self)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(discardAction)
        presentViewController(alertController, animated: true) { () -> Void in }
    }
}
