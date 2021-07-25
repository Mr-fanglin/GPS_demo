//
//  AppDelegate.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/8/17.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit
import CoreData
import MagicalRecord
import SwiftyJSON

@available(iOS 10.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if launchOptions != nil {
            if let localNotification = launchOptions![UIApplication.LaunchOptionsKey.localNotification] as? UILocalNotification {
                if let dict = localNotification.userInfo {
                    //清除所有通知
                    UIApplication.shared.cancelAllLocalNotifications()
                }
                
            }
        }
        // 通知
        if #available(iOS 8.0, *) {
            let uns = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(uns)
        }
        
        /*------初始化数据库------*/
        MagicalRecord.setupCoreDataStack(withAutoMigratingSqliteStoreNamed: "SmartTile_Gps.sqlite")
        
        /*------ 网易云信 -------*/
        XCXinChatTools.shared.registerNIMManager()
        
        /*------ 视图 --------*/
        window = UIWindow.init(frame: UIScreen.main.bounds)
        if let window = window {
            window.backgroundColor = .white
        }
        //启动跳转
        let tabbarVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()
        self.window?.rootViewController = tabbarVC
        return true
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        //清除所有通知
        UIApplication.shared.cancelAllLocalNotifications()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        UIApplication.shared.applicationIconBadgeNumber = XCXinChatTools.shared.getAllUnreadCount()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        UIApplication.shared.applicationIconBadgeNumber = XCXinChatTools.shared.getAllUnreadCount()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        //清除所有通知
        UIApplication.shared.cancelAllLocalNotifications()
    }

    // MARK: - Core Data stack

    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "SmartTile_Gps")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

