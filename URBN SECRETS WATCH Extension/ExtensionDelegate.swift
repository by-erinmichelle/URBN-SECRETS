//
//  ExtensionDelegate.swift
//  URBN SECRETS WATCH Extension
//
//  Created by Erin Wiegman on 3/10/18.
//  Copyright © 2018 Erin Wiegman. All rights reserved.
//
import WatchKit
import UserNotifications
class ExtensionDelegate: NSObject, WKExtensionDelegate,UNUserNotificationCenterDelegate {
    var isGrantedAccess = false

    
    
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        setCategories()
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound,.alert]) { (granted, error) in
            self.isGrantedAccess = granted
            if granted == false {
                print("Launch Notification Error: \(error?.localizedDescription)")
            }
        }
    }
    
    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }
    
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                backgroundTask.setTaskCompleted()
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompleted()
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompleted()
            default:
                // make sure to complete unhandled task types
                task.setTaskCompleted()
            }
        }
    }
    //MARK: Delegates
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound,.alert])
        print("will present!")
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let actionIdentifier = response.actionIdentifier
        if actionIdentifier == "dessert.action"{
            print("Dessert")
        }
        if actionIdentifier == "next.action"{
            print("Next Action")
        }
        if actionIdentifier == "snooze.action"{
            print("Snoozing!!!")
        }
        if actionIdentifier == "stop.action"{
            let center = UNUserNotificationCenter.current()
            center.removeAllDeliveredNotifications()
            center.removeAllPendingNotificationRequests()
        }
        completionHandler()
    }
    
    // MARK: -  Categories and  Notification actions
    func setCategories(){
        // Declare Actions ---------------------------------------
        let snoozeAction = UNNotificationAction(identifier: "snooze.action", title: "Snooze", options: [])
        let nextAction = UNNotificationAction(identifier: "next.action", title: "Next", options: [])
        let dessertAction = UNNotificationAction(identifier: "dessert.action", title: "Hot Fudge", options: [])
        let stopAction = UNNotificationAction(identifier: "stop.action", title: "No Dessert", options: [])
        
        // Declare and set the categories ------------------------
        let pizzaCategory = UNNotificationCategory(identifier: "pizza.category", actions: [snoozeAction,nextAction,dessertAction], intentIdentifiers: [], options: [])
        let dessertCategory = UNNotificationCategory(identifier: "dessert.category", actions: [dessertAction,stopAction], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([pizzaCategory,dessertCategory])
    }
}


//// watch connectivity----------------------------------
////  ExtensionDelegate.swift
////  URBN SECRETS WATCH Extension
////
////  Created by Erin Wiegman on 3/10/18.
////  Copyright © 2018 Erin Wiegman. All rights reserved.
////
//
//import WatchKit
//import WatchConnectivity
//
//class ExtensionDelegate: NSObject, WKExtensionDelegate {
//
//    private var wcBackgroundTasks = [WKWatchConnectivityRefreshBackgroundTask]()
//
//    override init() {
//        super.init()
//        assert(WCSession.isSupported(), "This sample requires a platform supporting Watch Connectivity!")
//
//        // WKWatchConnectivityRefreshBackgroundTask should be completed – Otherwise they will keep consuming
//        // the background executing time and eventually causes an app crash.
//        // The timing to complete the tasks is when the current WCSession turns to not .activated or
//        // hasContentPending flipped to false (see completeBackgroundTasks), so KVO is set up here to observe
//        // the changes if the two properties.
//        //
//        WCSession.default.addObserver(self, forKeyPath: "activationState", options: [], context: nil)
//        WCSession.default.addObserver(self, forKeyPath: "hasContentPending", options: [], context: nil)
//
//        // Create the session coordinator to activate the session asynchronously as early as possible.
//        // In the case of being background launched with a task, this may save some background runtime budget.
//        //
//        _ = SessionCoordinator.shared
//    }
//
//    // When the WCSession's activationState and hasContentPending flips, complete the background tasks.
//    //
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
//                               change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        DispatchQueue.main.async {
//            self.completeBackgroundTasks()
//        }
//    }
//
//    // Compelete the background tasks, and schedule a snapshot refresh.
//    //
//    func completeBackgroundTasks() {
//        guard !wcBackgroundTasks.isEmpty else { return }
//
//        let session = WCSession.default
//        guard session.activationState == .activated && !session.hasContentPending else { return }
//
//        wcBackgroundTasks.forEach { $0.setTaskCompletedWithSnapshot(true) }
//
//        // Use FileLogger to log the tasks for debug purpose. A real app may remove the log
//        // to save the precious background time.
//        //
//        FileLogger.shared.append(line: "\(#function):\(wcBackgroundTasks) was completed!")
//
//        // Schedule a snapshot refresh if the UI is updated by background tasks.
//        //
//        let date = Date(timeIntervalSinceNow: 1)
//        WKExtension.shared().scheduleSnapshotRefresh(withPreferredDate: date, userInfo: nil) { error in
//
//            if let error = error {
//                print("scheduleSnapshotRefresh error: \(error)!")
//            }
//        }
//        wcBackgroundTasks.removeAll()
//    }
//
//    // Be sure to complete all the tasks - otherwise they will keep consuming the background executing
//    // time until the time is out of budget and the app is killed.
//    //
//    // WKWatchConnectivityRefreshBackgroundTask should be completed after the pending data is received
//    // so retain the tasks first. The retained tasks will be completed at the following cases:
//    // 1. hasContentPending flips to false, meaning all the pending data is received. Pending data means
//    //    the data received by the device prior to the WCSession getting activated.
//    //    More data might arrive, but it isn't pending when the session activated.
//    // 2. The end of the handle method.
//    //    This happens when hasContentPending can flip to false before the tasks are retained.
//    //
//    // If the tasks are completed before the WCSessionDelegate methods are called, the data will be delivered
//    // the app is running next time, so no data lost.
//    //
//    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
//        for task in backgroundTasks {
//
//            // Use FileLogger to log the tasks for debug purpose. A real app may remove the log
//            // to save the precious background time.
//            //
//            if let wcTask = task as? WKWatchConnectivityRefreshBackgroundTask {
//                wcBackgroundTasks.append(wcTask)
//                FileLogger.shared.append(line: "\(#function):\(wcTask.description) was appended!")
//            }
//            else {
//                task.setTaskCompletedWithSnapshot(true)
//                FileLogger.shared.append(line: "\(#function):\(task.description) was completed!")
//            }
//        }
//        completeBackgroundTasks()
//    }
//
//    func applicationDidFinishLaunching() {
//        // Perform any final initialization of your application.
//    }
//
//    func applicationDidBecomeActive() {
//        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    }
//
//    func applicationWillResignActive() {
//        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//        // Use this method to pause ongoing tasks, disable timers, etc.
//    }
//
//    //    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
//    //        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
//    //        for task in backgroundTasks {
//    //            // Use a switch statement to check the task type
//    //            switch task {
//    //            case let backgroundTask as WKApplicationRefreshBackgroundTask:
//    //                // Be sure to complete the background task once you’re done.
//    //                backgroundTask.setTaskCompletedWithSnapshot(false)
//    //            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
//    //                // Snapshot tasks have a unique completion call, make sure to set your expiration date
//    //                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
//    //            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
//    //                // Be sure to complete the connectivity task once you’re done.
//    //                connectivityTask.setTaskCompletedWithSnapshot(false)
//    //            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
//    //                // Be sure to complete the URL session task once you’re done.
//    //                urlSessionTask.setTaskCompletedWithSnapshot(false)
//    //            default:
//    //                // make sure to complete unhandled task types
//    //                task.setTaskCompletedWithSnapshot(false)
//    //            }
//    //        }
//    //    }
//
//}

