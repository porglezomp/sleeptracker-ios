//
//  ViewController.swift
//  Sleep Tracker
//
//  Created by Caleb Jones on 11/11/14.
//  Copyright (c) 2014 Caleb Jones. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController, SleepReviewResponder {
    var defaults: NSUserDefaults!
    var inBed = false
    var asleep = false
    var startTimeInBed: NSDate?
    var startTimeAsleep: NSDate?
    var endTimeAsleep: NSDate?
    var healthKitStore: HKHealthStore?
    lazy var categoryType: HKObjectType = { HKObjectType.categoryTypeForIdentifier(HKCategoryTypeIdentifierSleepAnalysis) }()
    
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showErrorIfInvalid", name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        if HKHealthStore.isHealthDataAvailable() {
            healthKitStore = HKHealthStore()
            healthKitStore!.requestAuthorizationToShareTypes(
                NSSet(object: categoryType),
                readTypes: NSSet(),
                completion: { (success: Bool, error: NSError!) -> Void in Void() })
        } else {
            println("Sorry, healthkit is unavailable!")
        }
        
        // This stores UserDefaults and updates the labels in the UI
        updateStatus()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        showErrorIfInvalid()
    }
    
    func showErrorIfInvalid() {
        if healthKitStore?.authorizationStatusForType(categoryType) != HKAuthorizationStatus.SharingAuthorized {
            self.performSegueWithIdentifier("errorSegue", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "errorSegue" {
            let vc = segue.destinationViewController as ErrorViewController
            vc.delegate = self
        } else if segue.identifier == "reviewSleepSegue" {
            let vc = segue.destinationViewController as ReviewSleepViewController
            vc.delegate = self
        }
    }
    
    @IBAction func returnFromError(segue: UIStoryboardSegue) {
    }
    
    @IBAction func returnFromSleepReview(segue: UIStoryboardSegue) {
        println("Okay, we're back!")
        let sample = HKCategorySample(
            type: HKObjectType.categoryTypeForIdentifier(HKCategoryTypeIdentifierSleepAnalysis),
            value: HKCategoryValueSleepAnalysis.Asleep.rawValue,
            startDate: startTimeAsleep,
            endDate: endTimeAsleep
        )
        saveSample(sample)
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
                value: HKCategoryValueSleepAnalysis.InBed.rawValue,
                startDate: start,
                endDate: end
            )
            
            saveSample(sample)
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
            endTimeAsleep = NSDate()
            self.performSegueWithIdentifier("reviewSleepSegue", sender: self)
        } else {
            // The user is going to sleep
            asleep = true
            startTimeAsleep = NSDate()
        }
        updateStatus()
    }
    
    func saveSample(sample: HKCategorySample) {
        if (healthKitStore != nil) {
            if healthKitStore!.authorizationStatusForType(categoryType) == HKAuthorizationStatus.SharingAuthorized {
                self.healthKitStore?.saveObject(sample, withCompletion: { (success: Bool, error: NSError!) -> Void in Void() })
            }
        }
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

