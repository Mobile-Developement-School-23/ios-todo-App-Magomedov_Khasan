//  AppDelegate.swift
//  Homework_1
//  Created by Хасан Магомедов on 10.06.2023.

import UIKit
import CocoaLumberjack
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    public let fileLogger: DDFileLogger = DDFileLogger()
    private func setupLogger() {
        DDLog.add(DDTTYLogger.sharedInstance!)
        
        // File Logger
        fileLogger.rollingFrequency = TimeInterval(60*60*24)
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger, with: .info)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupLogger()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    // MARK: - Core Data stack

        lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "ToDoItem")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                } else {
                    print("CD url - \(storeDescription.url?.absoluteString)")
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
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

