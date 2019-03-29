//
//  FinalBugViewController.swift
//  SoManyBugs
//
//  Created by Jarrod Parkes on 4/16/15.
//  Copyright (c) 2015 Jarrod Parkes. All rights reserved.
//

import UIKit

// MARK: - FinalBugViewController: UIViewController

class FinalBugViewController: UIViewController {

    // MARK: Properties
    
    let bugFactory = BugFactory.sharedInstance()
    let maxBugs = 100
    let moveDuration = 3.0
    let disperseDuration = 1.0    
    var bugs = [UIImageView]()

    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        let singleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
        view.addGestureRecognizer(singleTapRecognizer)                
    }

    // MARK: Bug Functions
    
    func addBugToView() {
        if bugs.count < maxBugs {
            let newBug = bugFactory.createBug()
            bugs.append(newBug)
            view.addSubview(newBug)
            moveBugsAnimation()
        }
    }

    func emptyBugsFromView() {
        for bug in self.bugs {
            bug.removeFromSuperview()
        }
        self.bugs.removeAll(keepingCapacity: true)
    }
    
    // MARK: View Animations
    
    func moveBugsAnimation() {
        UIView.animate(withDuration: moveDuration) {
            for bug in self.bugs {
                let randomPosition = CGPoint(x: CGFloat(arc4random_uniform(UInt32(UInt(self.view.bounds.maxX - bug.frame.size.width))) + UInt32(bug.frame.size.width/2)), y: CGFloat(arc4random_uniform(UInt32(UInt(self.view.bounds.maxY - bug.frame.size.height))) + UInt32(bug.frame.size.height/2)))
                bug.frame = CGRect(x: randomPosition.x - bug.frame.size.width/1.5, y: randomPosition.y - bug.frame.size.height/1.5, width: BugFactory.bugSize.width, height: BugFactory.bugSize.height)
            }
        }
    }
    
    func disperseBugsAnimation() {
        UIView.animate(withDuration: disperseDuration, animations: { () -> Void in
            for bug in self.bugs {
                let offScreenPosition = CGPoint(x: (bug.center.x - self.view.center.x) * 20, y: (bug.center.y - self.view.center.y) * 20)
                bug.frame = CGRect(x: offScreenPosition.x, y: offScreenPosition.y, width: BugFactory.bugSize.width, height: BugFactory.bugSize.height)
            }
        }, completion: { (finished) -> Void in
            if finished { self.emptyBugsFromView() }
        })
    }
    
    // MARK: Actions
    
    @IBAction func popToMasterView() {
        self.navigationController!.popToRootViewController(animated: true)
    }
}

// MARK: - FinalBugViewController (UIResponder)

extension FinalBugViewController {
    override var canBecomeFirstResponder: Bool { return true }
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake { disperseBugsAnimation() }
    }
    @objc func handleSingleTap(_ recognizer: UITapGestureRecognizer) { addBugToView() }
}

// MARK: - FinalBugViewController (CustomStringConvertible)

// NOTE: You don't have to conform to CustomStringConvertible since this is already done by FinalBugViewController's superclasses (via NSObject).

extension FinalBugViewController {

    override var description: String {
        return "FinalBugViewController contains \(bugs.count) bugs\n"
    }
    
}

// MARK: - FinalBugViewController (CustomDebugStringConvertible)

// NOTE: You don't have to conform to CustomDebugStringConvertible since this is already done by FinalBugViewController's superclasses (via NSObject).

extension FinalBugViewController {
    
    override var debugDescription: String {
        var index = 0
        var debugString = "FinalBugViewController contains \(bugs.count) bugs...\n"
        for bug in bugs {
            debugString = debugString + "Bug\(index): \(bug.frame)\n"
            index += 1
        }
        return debugString
    }
}

// MARK: - FinalBugViewController (debugQuickLookObject)

extension FinalBugViewController {
    
    func debugQuickLookObject() -> AnyObject? {
        
        let singleSquareLength: CGFloat = 10.0
        let squaresInRow = 10
        let imageSize = CGSize(width: singleSquareLength * CGFloat(squaresInRow), height: singleSquareLength * CGFloat(bugs.count / squaresInRow + 1))
        
        UIGraphicsBeginImageContextWithOptions(imageSize, true, 0)
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        for bug in bugs {
            bug.tintColor.set()
            UIRectFill(CGRect(x: x, y: y, width: singleSquareLength, height: singleSquareLength))
            x += singleSquareLength
            if x > CGFloat(squaresInRow) * singleSquareLength {
                y += singleSquareLength
                x = 0.0
            }
        }
        UIColor.yellow.set()
        UIRectFill(CGRect(x: x, y: y, width: singleSquareLength, height: singleSquareLength))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
