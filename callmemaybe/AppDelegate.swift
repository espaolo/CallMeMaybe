//
//  AppDelegate.swift
//  callmemaybe
//
//  Created by Paolo Esposito on 05/09/2020.
//  Copyright © 2020 Paolo Esposito. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    var navigationController: UINavigationController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
        
        if (UserDefaults.standard.object(forKey: "logged") as? Bool) != nil {
            //If already logged then show Contacts screen
            self.showContactsView()
        } else {
            //If not logged then show Login screen
            self.showLoginView()
        }
        return true
    }
    
    func showLoginView() {

        let loginViewController = LoginViewController()
        navigationController = UINavigationController(rootViewController: loginViewController)

         //It removes all view controllers from the navigation controller then sets the new root view controller and it pops.
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

    }

    func showContactsView() {

        let contactsViewController = ContactsViewController()
        navigationController = UINavigationController(rootViewController: contactsViewController)
        
         //It removes all view controllers from the navigation controller then sets the new root view controller and it pops.
         window?.rootViewController = navigationController

         //Navigation bar is hidden
        navigationController?.isNavigationBarHidden = false
        window?.makeKeyAndVisible()
        
     }

    
    
}

