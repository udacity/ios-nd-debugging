//
//  BugFactory.swift
//  SoManyBugs
//
//  Created by Jarrod Parkes on 4/17/15.
//  Copyright (c) 2015 Jarrod Parkes. All rights reserved.
//

import UIKit
import Foundation

// MARK: - BugFactory

class BugFactory {
    
    // MARK: Properties
    
    static let bugTints: [UIColor] = [.black, .brightBlueColor, .brightRedColor, .brightGreenColor]
    static let shakeRotations = [Double.pi/16, Double.pi/8, Double.pi/8, Double.pi/24]
    static let shakeDurations = [0.3, 3.0, 0.1, 0.5]
    static let bugSize = CGSize(width: 128, height: 128)
    
    enum BugType: Int {
        case basic, slow, fast, smooth
    }
    
    var currentBugType = BugType.basic
    
    // MARK: Create Bug
    
    func createBug() -> UIImageView {
        let bug = UIImageView(frame: CGRect(x: -100, y: -100, width: 128, height: 128))
        bug.image = UIImage(named: "spider")
        bug.tintColor = BugFactory.bugTints[currentBugType.rawValue]
        
        // add simple "shake" key-frame animation
        // for explanation, see http://www.objc.io/issue-12/animations-explained.html
        let shakeAnimation = CABasicAnimation(keyPath: "transform.rotation")
        shakeAnimation.toValue = 0.0
        shakeAnimation.fromValue = BugFactory.shakeRotations[currentBugType.rawValue]
        shakeAnimation.duration = BugFactory.shakeDurations[currentBugType.rawValue]
        shakeAnimation.repeatCount = Float.infinity
        shakeAnimation.autoreverses = true
        shakeAnimation.isRemovedOnCompletion = false
        bug.layer.add(shakeAnimation, forKey: "shake")
        
        return bug
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> BugFactory {
        
        struct Singleton {
            static var sharedInstance = BugFactory()
        }
        
        return Singleton.sharedInstance
    }
}
