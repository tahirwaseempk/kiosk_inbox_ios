//
//  AppDelegate.swift
//  Inbox
//
//  Created by Amir Akram on 21/06/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import UIKit
import CoreData
import Fabric
import Crashlytics

import Firebase
import UserNotifications

let PushNotificationName = Notification.Name("PushNotificationRecieved")
let APNSPushNotificationName = Notification.Name("APNSPushNotificationRecieved")

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate
{
    var window: UIWindow?
    //let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        
        Fabric.with([Crashlytics.self])
        //self.logUser()
        
        // Override point for customization after application launch.
        //application.applicationIconBadgeNumber = 0
        self.updateBadgeCount()
        
        IQKeyboardManager.sharedManager().enable = true
        
        switch environment {
        case .texting_Line:
            print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ Texting_Line $$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
        case .sms_Factory:
            print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ Sms_Factory $$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
        case .fan_Connect:
            print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ Fan_Connect $$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
        case .photo_Texting:
            print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ Photo_Texting $$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
        }
        
        // FireBase Integration started here
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { (isSuccess, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            })
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        FirebaseApp.configure()
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func logUser() {
        // TODO: Use the current user's information
        // You can call any combination of these three methods
        Crashlytics.sharedInstance().setUserEmail("user@fabric.io")
        Crashlytics.sharedInstance().setUserIdentifier("12345")
        Crashlytics.sharedInstance().setUserName("Test User")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        UserDefaults.standard.synchronize()
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        @available(iOS 10.0, *)
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            
            print("Message \(response.notification.request.content.userInfo)")
            
            completionHandler()
        }
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
/*
        // Firebase notification received
        @available(iOS 10.0, *)
        func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
            
            // custom code to handle push while app is in the foreground
            print("Handle push from foreground \(notification.request.content.userInfo)")
            
            
            // Reading message body
            let dict = notification.request.content.userInfo["aps"] as! NSDictionary
            
            var messageBody:String?
            var messageTitle:String = "Alert"
            
            if let alertDict = dict["alert"] as? Dictionary<String, String> {
                messageBody = alertDict["body"]!
                if alertDict["title"] != nil { messageTitle  = alertDict["title"]! }
                
            } else {
                messageBody = dict["alert"] as? String
            }
            
            print("Message body is \(messageBody!) ")
            print("Message messageTitle is \(messageTitle) ")
            
            // Let iOS to display message
            completionHandler([.alert,.sound, .badge])
        }
 */
        
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        
        CoreDataManager.coreDataManagerSharedInstance.saveContext()
        UserDefaults.standard.synchronize()
    }
    
    // Called when Registration is successfull
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("========== >>>>>>>>>> Remote instance ID token: \(result.token) <<<<<<<<<< ==========")
                
                UserDefaults.standard.set(result.token, forKey: "fireBaseToken")
                UserDefaults.standard.set(deviceToken, forKey: "deviceToken")
                UserDefaults.standard.synchronize()
                
                NotificationCenter.default.post(name: APNSPushNotificationName, object: nil)

            }
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Registration failed!")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("=========>>>>>>>>>> Entire message \(userInfo)")
        
        let state : UIApplication.State = application.applicationState
        switch state {
        case UIApplication.State.active:
            print("If needed notify user about the message")
            NotificationCenter.default.post(name: PushNotificationName, object: nil)

        default:
            print("Run code to download content")
            NotificationCenter.default.post(name: PushNotificationName, object: nil)
        }
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Token refreshed")
    }
    
    func updateBadgeCount()
    {
        var badgeCount = UIApplication.shared.applicationIconBadgeNumber
        if badgeCount > 0
        {
            badgeCount = badgeCount-1
        }
        
        UIApplication.shared.applicationIconBadgeNumber = badgeCount
    }
}

