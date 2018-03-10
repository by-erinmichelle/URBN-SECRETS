//
//  ViewController.swift
//  URBN SECRETS
//
//  Created by Erin Wiegman on 3/10/18.
//  Copyright © 2018 Erin Wiegman. All rights reserved.
//

import UIKit

// 1. Add the ESTTriggerManagerDelegate protocol
class ViewController: UIViewController, ESTTriggerManagerDelegate {
    // 2. Add the trigger manager
    let triggerManager = ESTTriggerManager()

    let colors = [UIColor(red: 84/255, green: 77/255, blue: 160/255, alpha: 1), UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // 3. Set the trigger manager's delegate
        self.triggerManager.delegate = self
        let rule2 = ESTOrientationRule.orientationEquals(
            .horizontalUpsideDown, for: .bag)
//        changed 20 ft away
        let rule1 = ESTProximityRule.inRangeOf(.car)
//        let rule2 = ESTMotionRule.motionStateEquals(
//            true, forNearableIdentifier: "ee84b8102024b5b3")

        
        let trigger = ESTTrigger(rules: [rule1, rule2], identifier: "trigger")
        
        self.triggerManager.startMonitoring(for: trigger)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func triggerManager(_ manager: ESTTriggerManager,
                        triggerChangedState trigger: ESTTrigger) {
        if (trigger.identifier == "trigger" && trigger.state == true) {
            self.view.backgroundColor = self.colors[1]
            
        } else {
//            print("Goodnight")
        }
    }
}

