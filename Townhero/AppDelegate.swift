//
//  AppDelegate.swift
//  Townhero
//
//  Created by Mohamed on 6/26/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//



import UIKit
import Firebase
import FBSDKCoreKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseMessaging




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var defaults: NSUserDefaults?
    var window: UIWindow?
    var authUser: FIRUser?
    
    
    
    //    
    override init() {
        
        FIRApp.configure()
        
    }
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print(error)
        
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool{
        
        //        FIRApp.configure()
                
        let colorView = UIView()
        colorView.backgroundColor = UIColor.whiteColor()
        UITableViewCell.appearance().selectedBackgroundView = colorView
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        authUser = FIRAuth.auth()?.currentUser
        
        let notificationTypes : UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound]
        
        let notificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
        
        application.registerForRemoteNotifications()
        application.registerUserNotificationSettings(notificationSettings)
        
        
        self.defaults = NSUserDefaults.standardUserDefaults()
        let firstLaunch = defaults!.boolForKey("FirstLaunch")
        
        if firstLaunch  {
            print("Not first launch.")
            
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            
            let initialViewController = storyboard.instantiateViewControllerWithIdentifier("LoginView") 
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
            
            
        }
        else {
            print("First launch, setting NSUserDefault.")
            
            let myValue:NSString = "0"
            NSUserDefaults.standardUserDefaults().setObject(myValue, forKey:"safetySwitch")
            NSUserDefaults.standardUserDefaults().setObject(myValue, forKey:"parkingSwitch")
            NSUserDefaults.standardUserDefaults().setObject(myValue, forKey:"envirementSwitch")
            NSUserDefaults.standardUserDefaults().setObject(myValue, forKey:"serviceSwitch")
            
            
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            
            let storyboard = UIStoryboard(name: "Instructions", bundle: nil)
            
            let initialViewController = storyboard.instantiateViewControllerWithIdentifier("InstructView") as UIViewController
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
            self.defaults!.setBool(true, forKey: "FirstLaunch")
            
        }

        return true
    }
    
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        
        return handled
        
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        print("MessageID: \(userInfo["gcm_message_id"]!)")
        print(userInfo)
        
        
        
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        //Tricky line
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.Unknown)
        print("Device Token:", tokenString)
        // kFIRInstanceIDTokenRefreshNotificatio
    }
    
    
  }

