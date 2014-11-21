//
//  MissingHealthKitViewController.swift
//  Sleep Tracker
//
//  Created by Caleb Jones on 11/21/14.
//  Copyright (c) 2014 Caleb Jones. All rights reserved.
//

import UIKit

class MissingHealthKitViewController: UIViewController {
    var delegate: ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkIfValid", name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkIfValid()
    }

    @IBAction func openSupportSite(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://porglezomp.github.io/sleeptracker-ios/support")!)
    }
    
    func checkIfValid() {
        if delegate?.healthKitStore? != nil {
            self.performSegueWithIdentifier("returnFromError", sender: self)
        }
    }
}