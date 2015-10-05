//
//  AppDelegate.swift
//  wefsixtwitter
//
//  Created by Morgan Wildermuth on 10/3/15.
//  Copyright © 2015 WEF6. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //stroyboard is just xml file
    var storyboard = UIStoryboard(name: "Main", bundle: nil)


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //subscribe to event and then call userDidLogout
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDidLogout", name: userDidLogoutNotification, object: nil)
        
        if User.currentUser != nil {
            let vc = storyboard.instantiateViewControllerWithIdentifier("Tweets")
            let navCtrl = storyboard.instantiateInitialViewController() as! UINavigationController
            navCtrl.viewControllers = [vc]
            window?.rootViewController = navCtrl
        }
        return true
    }
    
    func userDidLogout(){
        var vc = storyboard.instantiateInitialViewController()
        window?.rootViewController = vc
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //called when someone tries to redirect to us from url; at this point we know if this is called it must've been twitter because nothing else is calling us right now
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        //check open url related to twitter; path says oauth? if so direct to twitter client open url if necessary
        TwitterClient.sharedInstance.openURL(url)
        return true
    }
}

