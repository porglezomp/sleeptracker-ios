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
    @IBOutlet weak var sleepDurationLabel: UILabel!
    
    var newStartTimeAsleep: NSDate {
        get {
            let time = delegate.startTimeAsleep!.dateByAddingTimeInterval(NSTimeInterval(minutes*60))
            // If it goes too far, clip it to the end time so we don't get an error
            if time.timeIntervalSince1970 > delegate.endTimeAsleep!.timeIntervalSince1970 {
                return delegate.endTimeAsleep!
            }
            return time
        }
    }
    
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
        updateLabel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.selectRow(3, inComponent: 0, animated: false)
        updateLabel()
    }
    
    func updateLabel() {
        func formatInterval(interval: NSTimeInterval) -> String {
            let hours = Int(interval / 3600)
            let hoursPlural = hours != 1 ? "s" : ""
            let minutes = Int((interval / 60) % 60)
            let minutesPlural = minutes != 1 ? "s" : ""
            let seconds  = Int(interval % 60)
            let secondsPlural = seconds != 1 ? "s" : ""
            if hours > 0 {
                return "\(hours) hour\(hoursPlural) \(minutes) minute\(minutesPlural)"
            } else if minutes > 0 {
                return "\(minutes) minute\(minutesPlural)"
            } else {
                return "\(seconds) second\(secondsPlural)"
            }
        }
        
        sleepDurationLabel.text = formatInterval(delegate.endTimeAsleep!.timeIntervalSinceDate(self.newStartTimeAsleep))
    }
    
    @IBAction func submitMinutes(sender: AnyObject) {
        println("\(minutes)")
        delegate.startTimeAsleep = newStartTimeAsleep
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
