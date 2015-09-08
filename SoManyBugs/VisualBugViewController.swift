//
//  VisualBugViewController.swift
//  SoManyBugs
//
//  Created by Jarrod Parkes on 4/16/15.
//  Copyright (c) 2015 Jarrod Parkes. All rights reserved.
//

import UIKit

class VisualBugViewController: UIViewController {

    // MARK: - Properties
    
    let bugFactory = BugFactory.sharedInstance()
    let maxBugs = 100
    let moveDuration = 3.0
    let disperseDuration = 1.0
    
    var bugs = [UIImageView]()

    // MARK: - View Events
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        let singleTapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        view.addGestureRecognizer(singleTapRecognizer)                
    }

    // MARK: - Bug Functions
    
    func addBugToView() {
        if bugs.count < maxBugs {
            let newBug = bugFactory.createBug()
            bugs.append(newBug)
            view.addSubview(newBug)
            moveBugsAnimation()
        }
    }

    func emptyBugsFromView() {
        // TODO: Empty the bugs from view!
    }
    
    // MARK: - View Animations
    
    func moveBugsAnimation() {
        UIView.animateWithDuration(moveDuration) {
            for bug in self.bugs {
                let randomPosition = CGPoint(x: CGFloat(arc4random_uniform(UInt32(UInt(self.view.bounds.maxX - bug.frame.size.width))) + UInt32(bug.frame.size.width/2)), y: CGFloat(arc4random_uniform(UInt32(UInt(self.view.bounds.maxY - bug.frame.size.height))) + UInt32(bug.frame.size.height/2)))
                bug.bounds = CGRect(x: randomPosition.x - bug.frame.size.width/1.5, y: randomPosition.y - bug.frame.size.height/1.5, width: BugFactory.bugSize.width, height: BugFactory.bugSize.height)
            }
        }
    }
    
    func disperseBugsAnimation() {
        UIView.animateWithDuration(disperseDuration, animations: { () -> Void in
            for bug in self.bugs {
                let offScreenPosition = CGPoint(x: (bug.center.x - self.view.center.x) * -20, y: (bug.center.y - self.view.center.y) * -20)
                bug.frame = CGRect(x: offScreenPosition.x, y: offScreenPosition.y, width: BugFactory.bugSize.width, height: BugFactory.bugSize.height)
            }
            }, completion: { (finished) -> Void in
                if finished { self.emptyBugsFromView() }
        })
    }
    
    // MARK: - Actions    
    
    @IBAction func popToMasterView() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}

// MARK: - UIResponder

extension VisualBugViewController {
    override func canBecomeFirstResponder() -> Bool { return true }
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake { disperseBugsAnimation() }
    }
    func handleSingleTap(recognizer: UITapGestureRecognizer) { addBugToView() }
}


// MARK: - debugQuickLookObject

extension VisualBugViewController {
    
    func debugQuickLookObject() -> AnyObject? {

        let singleSquareLength: CGFloat = 10.0
        let squaresInRow = 10
        let imageSize = CGSizeMake(singleSquareLength * CGFloat(squaresInRow), singleSquareLength * CGFloat(bugs.count / squaresInRow + 1))

        UIGraphicsBeginImageContextWithOptions(imageSize, true, 0)
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        for bug in bugs {
            bug.tintColor.set()
            UIRectFill(CGRectMake(x, y, singleSquareLength, singleSquareLength))
            x += singleSquareLength
            if x > CGFloat(squaresInRow) * singleSquareLength {
                y += singleSquareLength
                x = 0.0
            }
        }
        UIColor.yellowColor().set()
        UIRectFill(CGRectMake(x, y, singleSquareLength, singleSquareLength))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}