//
//  ReviewBedViewController.swift
//  Sleep Tracker
//
//  Created by Caleb Jones on 11/15/14.
//  Copyright (c) 2014 Caleb Jones. All rights reserved.
//

import UIKit

protocol BedViewDelegate {
    var startTimeInBed: NSDate? { get }
    var endTimeInBed: NSDate? { get }
}

class ReviewBedViewController: UIViewController {
    @IBOutlet weak var enterBedLabel: UILabel!
    @IBOutlet weak var exitBedLabel: UILabel!
    @IBOutlet weak var bedDurationLabel: UILabel!
    var delegate: BedViewDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let formatter = NSDateFormatter()
        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        formatter.dateStyle = NSDateFormatterStyle.NoStyle
        enterBedLabel.text = formatter.stringFromDate(delegate.startTimeInBed!)
        exitBedLabel.text = formatter.stringFromDate(delegate.endTimeInBed!)
        bedDurationLabel.text = formatInterval(delegate.endTimeInBed!.timeIntervalSinceDate(delegate.startTimeInBed!))
    }

    @IBAction func discard(sender: AnyObject) {
        var alertController = UIAlertController(title: nil, message: "Are you sure you want to discard this? It will delete the current data.", preferredStyle: UIAlertControllerStyle.ActionSheet)
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action: UIAlertAction!) -> Void in }
        var discardAction = UIAlertAction(title: "Discard", style: UIAlertActionStyle.Destructive) { (action: UIAlertAction!) -> Void in
            self.performSegueWithIdentifier("discardBedReview", sender: self)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(discardAction)
        presentViewController(alertController, animated: true) { () -> Void in }
    }
    
    @IBAction func submit(sender: AnyObject) {
        self.performSegueWithIdentifier("submitBedReview", sender: self)
    }
    
}
