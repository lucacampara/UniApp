//
//  AppDelegate.swift
//  UniApp
//
//  Created by Luca Campara on 21/06/17.
//  Copyright © 2017 tsam_its. All rights reserved.
//

import UIKit
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, controllaValiditaToken {

    var window: UIWindow?
    let gestoreChiamte = ChiamateAPI()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application 
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        gestoreChiamte.delegateControlloToken = self
        let token = UserDefaults.standard.string(forKey: ViewController.USER_TOKEN)
        if token != nil {
            print("c'è token")
            gestoreChiamte.controllaValiditaToken(access_token: token!)
        } else {
            print("no token")
        }

        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    func validitaToken(validita: Bool) {
        print("VALIDITA ", validita)
        if !validita {
            let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "loginController") as UIViewController
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = loginViewController
            self.window?.makeKeyAndVisible()
        }
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
        
        FBSDKAppEvents.activateApp()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    /*func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
       
        FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options., annotation: <#T##Any!#>)
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }*/


}

