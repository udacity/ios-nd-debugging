//
//  PrintSettingsViewController.swift
//  SoManyBugs
//
//  Created by Jarrod Parkes on 4/17/15.
//  Copyright (c) 2015 Jarrod Parkes. All rights reserved.
//

import UIKit

// MARK: - PrintSettingsViewController: UIViewController

class PrintSettingsViewController: UIViewController {
    
    // MARK: Properties
    
    let bugFactory = BugFactory.sharedInstance()
    
    // MARK: Outlets
    
    @IBOutlet weak var currentBugTypeImageView: UIImageView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentBugTypeImageView.tintColor = BugFactory.bugTints[bugFactory.currentBugType.rawValue]
    }
    
    // MARK: Actions
    
    @IBAction func dismissSettingsTouched(sender: AnyObject) { self.dismissViewControllerAnimated(true, completion: nil) }
    
    @IBAction func bugTypeSelected(sender: UIButton) {        
        bugFactory.currentBugType = BugFactory.BugType(rawValue: Int(sender.currentTitle!)!)!
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}