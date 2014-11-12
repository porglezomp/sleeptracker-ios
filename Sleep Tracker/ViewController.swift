//
//  ViewController.swift
//  Sleep Tracker
//
//  Created by Caleb Jones on 11/11/14.
//  Copyright (c) 2014 Caleb Jones. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    var defaults: NSUserDefaults!
    var inBed = false
    var asleep = false
    var startTimeInBed: NSDate?
    var startTimeAsleep: NSDate?
    
    @IBOutlet weak var timeInBedLabel: UILabel!
    @IBOutlet weak var timeAsleepLabel: UILabel!
    @IBOutlet weak var bedButton: UIButton!
    @IBOutlet weak var sleepButton: UIButton!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        // Make a convenience variable for UserDefaults
        self.defaults = NSUserDefaults.standardUserDefaults()

        // Set the values to the value stored in the UserDefaults.
        // The bools default to false if they've never been initialized,
        //  but this is fine since that's the default value we want.
        inBed = defaults.boolForKey("In Bed")
        asleep = defaults.boolForKey("Asleep")
        
        // We don't care if these are nil, since that's an appropriate default.
        // We'll never look at these except when we know there's a value
        startTimeInBed = defaults.objectForKey("Start In Bed") as NSDate?
        startTimeAsleep = defaults.objectForKey("Start Asleep") as NSDate?
        
        // This stores UserDefaults and updates the labels in the UI
        updateStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func toggleInBed(sender: AnyObject) {
        if self.inBed {
            // The user is getting out of bed
            inBed = false
            // Save the data
            let end = NSDate()
            let start = startTimeInBed!
            let sample = HKCategorySample(
                type: HKObjectType.categoryTypeForIdentifier(HKCategoryTypeIdentifierSleepAnalysis),
                value: HKCategoryValueSleepAnalysis.Asleep.rawValue,
                startDate: start,
                endDate: end
            )
            println("In bed for \(sample)")
        } else {
            // The user has gotten into bed
            inBed = true
            startTimeInBed = NSDate()
        }
        updateStatus()
    }
    
    @IBAction func toggleSleeping(sender: AnyObject) {
        if self.asleep {
            // The user just woke up
            asleep = false
            let end = NSDate()
            let start = startTimeAsleep!
            let sample = HKCategorySample(
                type: HKObjectType.categoryTypeForIdentifier(HKCategoryTypeIdentifierSleepAnalysis),
                value: HKCategoryValueSleepAnalysis.Asleep.rawValue,
                startDate: start,
                endDate: end
            )
            println("Asleep for \(sample)")
        } else {
            // The user is going to sleep
            asleep = true
            startTimeAsleep = NSDate()
        }
        updateStatus()
    }
    
    func updateStatus() {
        // Save the values in UserDefaults so they'll remain
        //  even if the user closes the app
        defaults.setBool(asleep, forKey: "Asleep")
        defaults.setBool(inBed, forKey: "In Bed")
        defaults.setObject(startTimeAsleep, forKey: "Start Asleep")
        defaults.setObject(startTimeInBed, forKey: "Start In Bed")
        
        // Set the labels in the GUI
        //  (\(startTimeAsleep!)) (\(startTimeInBed!))
        timeAsleepLabel.text = asleep ? "Asleep" : "Awake"
        timeInBedLabel.text = inBed ? "In bed " : "Not in bed"
        sleepButton.setTitle(asleep ? "Wake up" : "Sleep", forState: UIControlState.Normal)
        bedButton.setTitle(inBed ? "Get up" : "Get in bed", forState: UIControlState.Normal)
        
    }
}

