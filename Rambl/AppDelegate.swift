//
//  AppDelegate.swift
//  Rambl
//
//  Created by Ricardo Contreras on 1/14/17.
//  Copyright © 2017 rcr. All rights reserved.
//

import UIKit
import Firebase
import AWSS3
//import AWSCognitoIdentityProvider
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        configureFirebase()
        configureAWS()
        requestNotificationsAuthorization()
        return true
    }
    
    // TODO: Check if this works with @escaping
    // since it's changing the funcs signature
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void)
    {
        AWSS3TransferUtility.interceptApplication(application, handleEventsForBackgroundURLSession:identifier, completionHandler:completionHandler)
    }

    func applicationWillResignActive(_ application: UIApplication)
    {
    }

    func applicationDidEnterBackground(_ application: UIApplication)
    {
    }

    func applicationWillEnterForeground(_ application: UIApplication)
    {
    }

    func applicationDidBecomeActive(_ application: UIApplication)
    {
    }

    func applicationWillTerminate(_ application: UIApplication)
    {
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {        
    }
    
    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
    }
}

private extension AppDelegate
{
    func configureFirebase() {
        FIRApp.configure()
    }
    
    // TODO: Hide credentials
    func configureAWS() {
        let credentialsProvider = AWSCognitoCredentialsProvider(
            regionType: AWSRegionType.usEast1,
            identityPoolId: "us-east-1:52d5acb5-5830-4a9c-a80b-4c6c280af775")
        let configuration = AWSServiceConfiguration(
            region: AWSRegionType.usEast1,
            credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
    }
    
    func requestNotificationsAuthorization()
    {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (accepted, error) in
            if !accepted {
                print("Notification access denied.")
            }
            else
            {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void)
    {
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        
    }
}

