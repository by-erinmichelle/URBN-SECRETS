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

    let colors = [UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1), UIColor(red: 204/255, green: 255/255, blue: 204/255, alpha: 1)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // 3. Set the trigger manager's delegate
        self.triggerManager.delegate = self
//        let rule2 = ESTOrientationRule.orientationEquals(
//            .horizontalUpsideDown, for: .bag)
//        changed 20 ft away
        let rule1 = ESTProximityRule.inRangeOf(.car)
        let rule2 = ESTProximityRule.inRangeOf(.bag)

//        let rule2 = ESTMotionRule.motionStateEquals(
//            true, forNearableIdentifier: "ee84b8102024b5b3")

        
        let triggerCar = ESTTrigger(rules: [rule1], identifier: "triggerCar")
        let triggerBag = ESTTrigger(rules: [rule2], identifier: "triggerBag")

        
        self.triggerManager.startMonitoring(for: triggerCar)
        self.triggerManager.startMonitoring(for: triggerBag)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func triggerManager(_ manager: ESTTriggerManager,
                        triggerChangedState trigger: ESTTrigger) {
        if (trigger.identifier == "triggerCar" && trigger.state == true) {
            self.view.backgroundColor = self.colors[0]
            let myAlert = UIAlertController(title: "car found", message: "congrats", preferredStyle: .alert)
            self.present(myAlert, animated: true)
        }
       if (trigger.identifier == "triggerBag" && trigger.state == true) {
                self.view.backgroundColor = self.colors[1]
                let myAlert = UIAlertController(title: "bag found", message: "congrats", preferredStyle: .alert)
                self.present(myAlert, animated: true)
    }
}
}

