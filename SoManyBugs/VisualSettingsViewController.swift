//
//  VisualSettingsViewController.swift
//  SoManyBugs
//
//  Created by Jarrod Parkes on 4/17/15.
//  Copyright (c) 2015 Jarrod Parkes. All rights reserved.
//

import UIKit

class VisualSettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    let bugFactory = BugFactory.sharedInstance()
    @IBOutlet weak var currentBugTypeImageView: UIImageView!
    
    // MARK: - View Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentBugTypeImageView.tintColor = BugFactory.bugTints[bugFactory.currentBugType.rawValue]
    }
    
    // MARK: - IBActions
    
    @IBAction func dismissSettingsTouched(sender: AnyObject) { self.dismissViewControllerAnimated(true, completion: nil) }
    
    @IBAction func bugTypeSelected(sender: UIButton) {
        bugFactory.currentBugType = BugFactory.BugType(rawValue: Int(sender.currentTitle!)!)!
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}