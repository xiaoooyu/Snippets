//
//  AppDelegate.swift
//  Snippets
//
//  Created by Yin Xiaoyu on 3/21/17.
//  Copyright © 2017 Yin Xiaoyu. All rights reserved.
//

import UIKit
import CoreData
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var session: WCSession?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if WCSession.isSupported() {
            session = WCSession.default()
            if let _session = self.session {
                _session.delegate = self
                _session.activate()
            }
        }
        
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
        self.saveContext()
    }

    func handleShortcut(shortcutItem: UIApplicationShortcutItem) {
        let vc = self.window?.rootViewController as! ViewController
        
        switch shortcutItem.type {
        case ShortcutItems.newText.rawValue:
            vc.createNewTextSnippet()
        case ShortcutItems.newPhoto.rawValue:
            vc.createNewPhotoSnippet()
        default:
            break
        }
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        let vc = self.window!.rootViewController
        
        if vc?.presentedViewController != nil {
            let alert = UIAlertController(title: "Unfinished Snippet",
                                          message: "Do you want to continue creating this snippet, or erase and start a new snippet?",
                                          preferredStyle: .alert)
            let continueAction = UIAlertAction(title: "Continue", style: .default, handler: nil)
            let eraseAction = UIAlertAction(title: "Erase", style: .destructive, handler: {
                (alert: UIAlertAction!) -> Void in
                vc?.dismiss(animated: true, completion: nil)
                self.handleShortcut(shortcutItem: shortcutItem)
            })
            
            alert.addAction(continueAction)
            alert.addAction(eraseAction)
            vc?.presentedViewController!.present(alert, animated: true, completion: nil)
        } else {
            handleShortcut(shortcutItem: shortcutItem)
        }
    }
    
    enum ShortcutItems: String {
        case newText = "com.PacktPub.Snippets.createTextSnippet"
        case newPhoto = "com.PacktPub.Snippets.createPhotoSnippet"
    }
    
    // MARK: - Core Data Stack
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "SnippetData", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let url = urls.last!.appendingPathComponent("SingleViewCoreData.sqlite")
        do {
            try
                coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Replace this to handle the error appropriately
            let nserror = error as NSError
            print("Unsolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: Core Data Saving support
    func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this to handle the error appropriately
                let nserror = error as NSError
                print("Unsolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}

extension AppDelegate: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        return
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        return
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        return
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let textData = message["textData"] as? String, let vc = self.window!.rootViewController! as? ViewController {
            DispatchQueue.main.async( execute: {
                vc.saveTextSnippet(text: textData)
                vc.reloadSnippetData()
                vc.tableView.reloadData()
            })
        }
    }
}
