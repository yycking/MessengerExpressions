//
//  AppDelegate.swift
//  MessengerExpressions
//
//  Created by Wayne Yeh on 2017/2/15.
//  Copyright © 2017年 Wayne Yeh. All rights reserved.
//

import UIKit
import MapKit

import FBSDKMessengerShareKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, FBSDKMessengerURLHandlerDelegate {

    var window: UIWindow?
    let messengerUrlHandler = FBSDKMessengerURLHandler()
    var contextFBMessenger: FBSDKMessengerContext?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        messengerUrlHandler.delegate = self
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
    }

    public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if messengerUrlHandler.canOpen(url, sourceApplication: sourceApplication) {
            messengerUrlHandler.open(url, sourceApplication: sourceApplication)
        }
        
        return true
    }
    
    func messengerURLHandler(_ messengerURLHandler: FBSDKMessengerURLHandler!, didHandleReplyWith context: FBSDKMessengerURLHandlerReplyContext!) {
        contextFBMessenger = context
        
        guard let navigationController =  window?.rootViewController as? UINavigationController else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewController")
        object_setClass(controller, ReplyViewController.self)
        
        guard let replyController =  controller as? ReplyViewController else { return }
        replyController.region = MKCoordinateRegion(string: context.metadata)
        
        navigationController.pushViewController(replyController, animated: false)
    }
    
    func messengerURLHandler(_ messengerURLHandler: FBSDKMessengerURLHandler!, didHandleOpenFromComposerWith context: FBSDKMessengerURLHandlerOpenFromComposerContext!) {
        contextFBMessenger = context
    }
    
    func messengerURLHandler(_ messengerURLHandler: FBSDKMessengerURLHandler!, didHandleCancelWith context: FBSDKMessengerURLHandlerCancelContext!) {
        contextFBMessenger = context
    }
}

