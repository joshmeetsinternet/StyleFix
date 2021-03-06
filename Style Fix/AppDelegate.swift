//
//  AppDelegate.swift
//  Style Fix
//
//  Created by Vidamo on 23/11/2016.
//  Copyright © 2016 JTSoft Company Limited. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
  
    UINavigationBar.appearance().barTintColor = UIColor.black
    UINavigationBar.appearance().tintColor = UIColor.flatWhite
    UITabBar.appearance().tintColor = UIColor.flatWhite
    UITabBar.appearance().barTintColor = UIColor.flatBlack
    
    FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
  
    if #available(iOS 10.0, *) {
      let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: {_,_ in })
      
      // For iOS 10 display notification (sent via APNS)
      UNUserNotificationCenter.current().delegate = self
      // For iOS 10 data message (sent via FCM)
      FIRMessaging.messaging().remoteMessageDelegate = self
      
    } else {
      
      let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }
    
    getLocations(context: managedObjectContext)
    
    FIRApp.configure()

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
      FBSDKAppEvents.activateApp()
  }

  func applicationWillTerminate(_ application: UIApplication) {
      // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
      // Saves changes in the application's managed object context before the application terminates.
      self.saveContext()
  }
  
  func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
      return FBSDKApplicationDelegate.sharedInstance().application(
          application,
          open: url,
          sourceApplication: sourceApplication,
          annotation: annotation)
  }

  // MARK: - Core Data stack

  lazy var managedObjectContext: NSManagedObjectContext = {
    
    if #available(iOS 10.0, *) {
      return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    } else {
      // iOS 9.0 and below - however you were previously handling it
      guard let modelURL = Bundle.main.url(forResource: "GoTutor", withExtension:"momd") else {
        fatalError("Error loading model from bundle")
      }
      guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
        fatalError("Error initializing mom from: \(modelURL)")
      }
      let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
      let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
      let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
      let docURL = urls[urls.endIndex-1]
      let storeURL = docURL.appendingPathComponent("Model.sqlite")
      do {
        try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
      } catch {
        fatalError("Error migrating store: \(error)")
      }
      managedObjectContext.persistentStoreCoordinator = psc
      return managedObjectContext
    }
  }()
  
  lazy var persistentContainer: NSPersistentContainer = {
      /*
       The persistent container for the application. This implementation
       creates and returns a container, having loaded the store for the
       application to it. This property is optional since there are legitimate
       error conditions that could cause the creation of the store to fail.
      */
      let container = NSPersistentContainer(name: "Style_Fix")
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

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
  
  // Receive displayed notifications for iOS 10 devices.
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo
    // Print message ID.
    print("Message ID: \(userInfo["gcm.message_id"]!)")
    
    // Print full message.
    print("%@ userInfo", userInfo)
    
    guard let aps = userInfo["aps"] as? [String: AnyObject] else {
      print("wrong aps")
      return
    }
    
    guard let alert = aps["alert"] as? [String: AnyObject], let _ = alert["body"] as? String else {
      print("wrong alert")
      return
    }
  }
  
  @available(iOS 10, *)
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    print("Userinfo \(response.notification.request.content.userInfo)")
  }
}

@available(iOS 10, *)
extension AppDelegate : FIRMessagingDelegate {
  // Receive data message on iOS 10 devices.
  func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
    print("%@ fcm delegate", remoteMessage.appData)
    
  }
}
