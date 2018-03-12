//
//  ViewController.swift
//  URBN SECRETS
//
//  Created by Erin Wiegman on 3/10/18.
//  Copyright © 2018 Erin Wiegman. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    var isGrantedAccess = false   //flag if User granted access
//    var pizzaStepIndex = 0
//    let pizzaSteps = ["Make Pizza","Roll Dough",  "Add Sauce","Add Cheese","Add Ingredients", "Bake", "Done"]
    
    // Image Attachment -----------------------------------------
    func pizzaImage()->[UNNotificationAttachment]{
        let path = Bundle.main.path(forResource: "pizzaImage", ofType: "png")
        let photoURL = URL(fileURLWithPath: path!)
        do {
            let attachment = try UNNotificationAttachment(identifier: "Pizza.Photo", url: photoURL, options: nil)
            return [attachment]
        } catch {
            print("the attachment was not loaded")
            return []
        }
    }
    
    
    //MARK:  - Schedule the Timed Notification
    func timedNotification(){
        if isGrantedAccess{   // <--- Check for Access
            // Content ------------------------------------------------
            let content = UNMutableNotificationContent()
            
            content.title = "Congrats!"
            content.body = "You found the Hybrid Lab"
            content.sound = UNNotificationSound.default()
            content.attachments = pizzaImage()
            
            // Category --------------------------------------
            content.categoryIdentifier = "pizza.category"
            
            // Trigger-------------------------------------------------
//            tells phone when to schedule notif
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0 , repeats: false)
            
            
            // Make and schedule the request ---------------------------
            let request = UNNotificationRequest(identifier: "Pizza", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) {
                (notificationError) in
                if let error = notificationError{
                    print("^Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    //MARK: - Notification Delegates
    // Once you adopt the protocol, add this method for in-app notification presentation.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.badge,.sound])
    }
    // Method to run code for actions
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        //Identify the action and request -------------------------------------
        let action = response.actionIdentifier
//        let request = response.notification.request
        
        //Respond to the action -----------------------------------------------
//        if action == "snooze.action"{
//            // Add the request back to the notification center
//            //--- code to handle attachments and apple watch
//            // must refresh the attachment to avoid URL error---. (Xcode 8.2.1)
//            let content = request.content.mutableCopy() as! UNMutableNotificationContent
//            content.attachments = pizzaImage()
//            let newRequest = UNNotificationRequest(identifier: request.identifier, content: content, trigger: request.trigger)
//            //-- If not using attachments, just send the request and skip all that above ---
//            //UNUserNotificationCenter.current().add(request) {
//            // Send the request back
//            UNUserNotificationCenter.current().add(newRequest) {
//                (notificationError) in
//                if let error = notificationError{
//                    print("Error(snooze.action): \(error.localizedDescription)")
//                }
//            }
        
//        }
        
        if action == "next.action"{
            // Add a new request to the notification center with different content
            // the subtitle will indicate the current step.
//            let content = request.content.mutableCopy() as! UNMutableNotificationContent
////            pizzaStepIndex = (pizzaStepIndex + 1) % pizzaSteps.count
////            content.subtitle = pizzaSteps[pizzaStepIndex]
//            content.attachments = pizzaImage() // See line 74 above
//            let newRequest = UNNotificationRequest(identifier: request.identifier, content: content, trigger: request.trigger)
//            UNUserNotificationCenter.current().add(newRequest) {
//                (notificationError) in
//                if let error = notificationError{
//                    let a = newRequest.content.attachments[0].url
//                    print("Error(next.action): \(error.localizedDescription) , URL \(a)")
//                }
//            }
            
        }
        completionHandler() // <--- Don't forget calling the completion Handler!
    }
    
    // MARK: -  Categories and  Notification actions
    func setCategories(){
        // Declare Actions ---------------------------------------
//        let snoozeAction = UNNotificationAction(identifier: "snooze.action", title: "Snooze", options: [])
        let nextAction = UNNotificationAction(identifier: "next.action", title: "Details", options: [])
        // Declare and set the categories ------------------------
        let pizzaCategory = UNNotificationCategory(identifier: "pizza.category", actions: [nextAction], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([pizzaCategory])
    }
    
    //MARK: - IB Actions
    @IBAction func startNotifications(_ sender: UIButton) {
        timedNotification()
        
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check the system if app is granted notification access
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {
            (granted,error) in
            self.isGrantedAccess = granted
            if granted {
                self.setCategories()  // add categories to the app
                UNUserNotificationCenter.current().delegate = self
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
}

}

////watch connectivity---------------------------------------------
////  ViewController.swift
////  URBN SECRETS
////
////  Created by Erin Wiegman on 3/10/18.
////  Copyright © 2018 Erin Wiegman. All rights reserved.
////
//
//import UIKit
//import WatchConnectivity
//
//
//// 1. Add the ESTTriggerManagerDelegate protocol
//class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ESTTriggerManagerDelegate, SessionDataProvider {
//
//    @IBOutlet weak var reachableLabel: UILabel!
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet var tableContainerView: UIView!
//    @IBOutlet weak var noteLabel: UILabel!
//    @IBOutlet weak var logView: UITextView!
//
//    // List the supported methods, shown in the main table.
//    //
//    let channels: [Channel] = [.updateAppContext, .sendMessage, .sendMessageData,
//                               .transferUserInfo, .transferFile, .transferCurrentComplicationUserInfo]
//
//    var currentChannel: Channel = .updateAppContext // Use .updateAppContext as the default method.
//    var currentColor: UIColor?
//
//
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
//        //Swift
//        if (WCSession.default.isReachable) {
//            self.view.backgroundColor = self.colors[2]
//            // Do something
//        }
//    }
//
//    //    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
//    //        //Swift
//    //        do {
//    //            let applicationDict = // Create a dict of application data
//    //                try WCSession.defaultSession().updateApplicationContext(applicationDict)
//    //        } catch {
//    //            // Handle errors here
//    //        }
//    //    }
//
//
//    // 2. Add the trigger manager
//    let triggerManager = ESTTriggerManager()
//
//    let colors = [UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1), UIColor(red: 204/255, green: 255/255, blue: 204/255, alpha: 1), UIColor(red: 104/255, green: 200/255, blue: 204/255, alpha: 1)]
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//
//        // Use the gray background color to be easier in design time. Now use white.
//        //
//        tableContainerView.backgroundColor = .white
//        tableView.rowHeight = 42
//
//        NotificationCenter.default.addObserver(
//            self, selector: #selector(type(of:self).dataDidFlow(_:)),
//            name: .dataDidFlow, object: nil
//        )
//
//        NotificationCenter.default.addObserver(
//            self, selector: #selector(type(of:self).activationDidComplete(_:)),
//            name: .activationDidComplete, object: nil
//        )
//
//        NotificationCenter.default.addObserver(
//            self, selector: #selector(type(of:self).reachabilityDidChange(_:)),
//            name: .reachabilityDidChange, object: nil
//        )
//
//        // 3. Set the trigger manager's delegate
//        self.triggerManager.delegate = self
//        let rule2 = ESTOrientationRule.orientationEquals(
//            .horizontalUpsideDown, for: .bag)
//        //        changed 20 ft away
//        let rule1 = ESTProximityRule.inRangeOf(.car)
//        //        let rule2 = ESTProximityRule.outsideRange(of: .bag)
//
//        //        let rule2 = ESTMotionRule.motionStateEquals(
//        //            true, forNearableIdentifier: "ee84b8102024b5b3")
//
//
//        let triggerCar = ESTTrigger(rules: [rule1, rule2], identifier: "triggerCar")
//        //        let triggerBag = ESTTrigger(rules: [rule2], identifier: "triggerBag")
//
//
//        self.triggerManager.startMonitoring(for: triggerCar)
//        //        self.triggerManager.startMonitoring(for: triggerBag)
//
//    }
//
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
//
//    // Append the message to the end of the text view and make sure it is visiable.
//    //
//    private func log(_ message: String) {
//        logView.text = logView.text! + "\n\n" + message
//        logView.scrollRangeToVisible(NSRange(location: logView.text.count, length: 1))
//    }
//
//    private func updateReachabilityColor() {
//        // WCSession.isReachable triggers a warning if the session is not activated.
//        //
//        var isReachable = false
//        if WCSession.default.activationState == .activated {
//            isReachable = WCSession.default.isReachable
//        }
//        reachableLabel.backgroundColor = isReachable ? .green : .red
//    }
//
//    // .dataDidFlow notification handler.
//    // Update the UI based on the userInfo dictionary of the notification.
//    //
//    @objc func dataDidFlow(_ notification: Notification) {
//
//        guard let userInfo = notification.userInfo as? [String: Any],
//            let channel = userInfo[UserInfoKey.channel] as? Channel else { return }
//
//        // Make sure to hide the note label if the log isn't empty.
//        //
//        defer {
//            noteLabel.isHidden = logView.text.isEmpty ? false: true
//        }
//
//        currentChannel = channel
//
//        // If an error occurs, show the error message and returns.
//        //
//        if let error = userInfo[UserInfoKey.error] as? String {
//            log("! \(channel.rawValue)...\(error)")
//            return
//        }
//
//        // If there is no error, the userInfo should contain a timed color.
//        //
//        guard let timedColor = userInfo[UserInfoKey.timedColor] as? [String: Any] else { return }
//
//        // Format the message and append it on the log view.
//        //
//        if let timeStamp = timedColor[PayloadKey.timeStamp] as? String,
//            let phrase = userInfo[UserInfoKey.phrase] as? Phrase {
//
//            log("#\(channel.rawValue)...\n\(phrase.rawValue) at \(timeStamp)")
//
//            if let fileURL = userInfo[UserInfoKey.fileURL] as? URL {
//
//                if let content = try? String(contentsOf: fileURL, encoding: .utf8), !content.isEmpty {
//                    log("\(fileURL.lastPathComponent)\n\(content)")
//                }
//                else {
//                    log("\(fileURL.lastPathComponent)\n")
//                }
//            }
//        }
//
//        // Get the color data and change the button color by reloading the table.
//        //
//        if let colorData = timedColor[PayloadKey.colorData] as? Data {
//            currentColor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
//            tableView.reloadData()
//        }
//    }
//
//    // .activationDidComplete notification handler.
//    //
//    @objc func activationDidComplete(_ notification: Notification) {
//        updateReachabilityColor()
//    }
//
//    // .reachabilityDidChange notification handler.
//    //
//    @objc func reachabilityDidChange(_ notification: Notification) {
//        updateReachabilityColor()
//    }
//
//    @IBAction func clear(_ sender: UIButton) {
//        logView.text = ""
//    }
//
//    // UITableViewDelegate and UITableViewDataSource.
//    //
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return channels.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Basic", for: indexPath)
//        cell.textLabel?.text = channels[indexPath.row].rawValue
//        cell.textLabel?.textColor = channels[indexPath.row] == currentChannel ? currentColor : nil
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        currentChannel = channels[indexPath.row]
//        SessionCoordinator.shared.send(dataProvider: self, channel: channels[indexPath.row])
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    func triggerManager(_ manager: ESTTriggerManager,
//                        triggerChangedState trigger: ESTTrigger) {
//        if (trigger.identifier == "triggerCar" && trigger.state == true) {
//            self.view.backgroundColor = self.colors[0]
//            //            let myAlert = UIAlertController(title: "car found", message: "congrats", preferredStyle: .alert)
//            //            self.present(myAlert, animated: true)
//
//        } else {
//            self.view.backgroundColor = self.colors[1]
//            //                let myAlert = UIAlertController(title: "bag found", message: "congrats", preferredStyle: .alert)
//            //                self.present(myAlert, animated: true)
//        }
//    }
//}



