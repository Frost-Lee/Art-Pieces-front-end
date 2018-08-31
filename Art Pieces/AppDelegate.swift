//
//  AppDelegate.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/13.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit
import CoreData
import BWWalkthrough

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if isFirstLaunch() {
            introduceMyself()
        }
        return true
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "LocalDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
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
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private func isFirstLaunch() -> Bool {
        if  UserDefaults.standard.bool(forKey: "everLaunched") == false {
            UserDefaults.standard.set(true, forKey: "everLaunched")
            UserDefaults.standard.set(true, forKey: "firstLaunch")
        } else {
            UserDefaults.standard.set(false, forKey: "firstLaunch")
        }
        return UserDefaults.standard.bool(forKey: "firstLaunch")
    }

}


extension AppDelegate: BWWalkthroughViewControllerDelegate {
    func walkthroughCloseButtonPressed() {
        window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func introduceMyself() {
        let walkThroughStoryboard = UIStoryboard(name: "WalkThrough", bundle: Bundle.main)
        let walkThrough = walkThroughStoryboard.instantiateInitialViewController()
            as! BWWalkthroughViewController
        let page_1 = walkThroughStoryboard.instantiateViewController(withIdentifier: "IntroducePage1")
        let page_2 = walkThroughStoryboard.instantiateViewController(withIdentifier: "IntroducePage2")
        let page_3 = walkThroughStoryboard.instantiateViewController(withIdentifier: "IntroducePage3")
        let page_login = UIStoryboard(name: "Login", bundle: Bundle.main).instantiateInitialViewController()
        walkThrough.delegate = self
        walkThrough.add(viewController: page_1)
        walkThrough.add(viewController: page_2)
        walkThrough.add(viewController: page_3)
        walkThrough.add(viewController: page_login!)
        delay(for: 1) {
            self.window?.rootViewController?.present(walkThrough, animated: true)
        }
    }
}
