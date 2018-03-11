//
//  InterfaceController.swift
//  URBN SECRETS WATCH Extension
//
//  Created by Erin Wiegman on 3/10/18.
//  Copyright © 2018 Erin Wiegman. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        <#code#>
    }

    
//    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
//        //Swift
//        let applicationDict = // Create a dict of application data
//        let transfer = WCSession.defaultSession().transferUserInfo(applicationDict)
//    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
//        set your apps up to receive data by creating a Watch Connectivity session
//        check if session is supported
        if (WCSession.isSupported()) {
//          set up default session
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
