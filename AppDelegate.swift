//
//  AppDelegate.swift
//

import UIKit
import Fabric
import TwitterKit
import SlideMenuControllerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private func createMenuView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        let menuViewController = storyboard.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
        let nvc: UINavigationController = UINavigationController(rootViewController: viewController)
        menuViewController.viewController = nvc
        let slideMenuController = SlideMenuController(mainViewController:nvc, leftMenuViewController: menuViewController)
        self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
    }
  
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        /* use fabric */
        Fabric.with([Twitter.self])
        
        /* use slide menu */
        createMenuView()
        
        /* change color */
        UINavigationBar.appearance().tintColor = UIColor.darkTextColor()
        
        return true
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

    // Universal Link対応
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        // typeをチェック
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            let webpageURL = userActivity.webpageURL!
            if !handleUniversalLink(URL: webpageURL) {
                // コンテンツをアプリで開けない場合は、Safariに戻す
                UIApplication.sharedApplication().openURL(webpageURL)
                return false
            }
            // 多分処理後にここかどこか適切な場所で呼ぶ必要あり
            restorationHandler([])
        }
        return true
    }
    private func handleUniversalLink(URL url: NSURL) -> Bool {
        if let components = NSURLComponents(URL: url, resolvingAgainstBaseURL: true), let host = components.host {
            switch host {
            case "ec2-52-68-185-145.ap-northeast-1.compute.amazonaws.com":
                return true
            default:
                return false
            }
            
        }
        return false
    }
}

