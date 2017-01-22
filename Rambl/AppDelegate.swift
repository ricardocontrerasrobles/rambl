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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        configureFirebase()
        configureAWS()
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
}

private extension AppDelegate
{
    func configureFirebase() {
        FIRApp.configure()
    }
    
    func configureAWS() {
        let credentialsProvider = AWSCognitoCredentialsProvider(
            regionType: AWSRegionType.usEast1,
            identityPoolId: "us-east-1:52d5acb5-5830-4a9c-a80b-4c6c280af775")
        let configuration = AWSServiceConfiguration(
            region: AWSRegionType.usEast1,
            credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
    }
}

