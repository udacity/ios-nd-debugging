//
//  BreakpointBugViewController.swift
//  SoManyBugs
//
//  Created by Jarrod Parkes on 4/16/15.
//  Copyright (c) 2015 Jarrod Parkes. All rights reserved.
//

import UIKit

// MARK: - BreakpointBugViewController: UIViewController

class BreakpointBugViewController: UIViewController {

    // MARK: Properties
    
    let bugFactory = BugFactory.sharedInstance()
    let maxBugs = 0
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
        addBugToView()
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
        let _ = navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - BreakpointBugViewController (UIResponder)

extension BreakpointBugViewController {
    override var canBecomeFirstResponder: Bool { return true }
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake { disperseBugsAnimation() }
    }
    @objc func handleSingleTap(_ recognizer: UITapGestureRecognizer) {
        addBugToView()
        addBugToView()
    }
}
