//
//  AppDelegate.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 15/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    fileprivate var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        DatabaseManager.shared.configure(schemaVersion: AppDefaults.schemeVersion)
        self.setNavigationBarStyle()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = MainController()
        self.window?.makeKeyAndVisible()
        return true
    }
    
    fileprivate func setNavigationBarStyle() {
        UINavigationBar.appearance().barTintColor = .global(.turquoise)
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.global(.white)]
        UINavigationBar.appearance().isTranslucent = false
    }
}

