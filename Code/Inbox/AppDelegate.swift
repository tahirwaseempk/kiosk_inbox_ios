//
//  AppDelegate.swift
//  Inbox
//
//  Created by Amir Akram on 21/06/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import UIKit
import CoreData
//import UserNotifications

let PushNotificationName = Notification.Name("PushNotificationRecieved")

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        // Override point for customization after application launch.
        
        //UIApplication.shared.isStatusBarHidden = true
        
        //registerForPushNotifications()
        
        application.applicationIconBadgeNumber = 0
        
        IQKeyboardManager.sharedManager().enable = true
        /**/
         // Initialize Pushy SDK
         let pushy = Pushy(UIApplication.shared)
         
         // Register the device for push notifications
         pushy.register({ (error, deviceToken) in
            
            application.applicationIconBadgeNumber = 0

         // Handle registration errors
         if error != nil {
         return print ("Registration failed: \(error!)")
         }
         
         // Print device token to console
         print("Pushy device token: \(deviceToken)")
         
         // Persist the device token locally and send it to your backend later
         UserDefaults.standard.set(deviceToken, forKey: "pushyToken")
         UserDefaults.standard.synchronize()
         // Subscribe the device for PubSub topic(s)
         pushy.subscribe(topic: "news", handler: { (error) in
         // Handle errors
         if error != nil {
         return print ("Subscribe failed: \(error!)")
         }
         
         // Subscribe successful
         print ("Subscribed to topic successfully")
         })
         })
         
         // Listen for push notifications
         pushy.setNotificationHandler({ (data, completionHandler) in
         // Print notification payload data
         print("Received notification: \(data)")
         
        NotificationCenter.default.post(name: PushNotificationName, object: nil)
         // You must call this completion handler when you finish processing
         // the notification (after fetching background data, if applicable)
         completionHandler(UIBackgroundFetchResult.newData)
         })
         /**/
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        CoreDataManager.coreDataManagerSharedInstance.saveContext()
    }
    /*
        func registerForPushNotifications() {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                print("Permission granted: \(granted)")
 
                guard granted else { return }
                self.getNotificationSettings()
            }
        }
 
        func getNotificationSettings() {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                print("Notification settings: \(settings)")
                guard settings.authorizationStatus == .authorized else { return }
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
 
 
        func application(_ application: UIApplication,
                         didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            let tokenParts = deviceToken.map { data -> String in
                return String(format: "%02.2hhx", data)
            }
 
            let token = tokenParts.joined()
            print("Device Token: \(token)")
 
            if token.characters.count>0 {
                let defaults = UserDefaults.standard
                defaults.set(token, forKey: "DeviceToken")
                defaults.synchronize()
            }
 
        }
 
        func application(_ application: UIApplication,
                         didFailToRegisterForRemoteNotificationsWithError error: Error) {
            print("Failed to register: \(error)")
        }
 
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {


    }
 */
}

