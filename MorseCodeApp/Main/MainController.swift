//
//  MainController.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 17/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import UIKit

class MainController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = [self.initAlphabetController(),
                                self.initTranslateController(),
                                self.initSettingsController(),
                                self.initAboutController()]
        self.tabBar.tintColor = .global(.turquoise)
    }
    
    fileprivate func initAlphabetController() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: DependencyContainer.resolve(AlphabetController.self))
        navigationController.tabBarItem = UITabBarItem(title: "AlphabetTitle".localized(),
                                                       image: .global(.alphabet),
                                                       selectedImage: .global(.alphabet))
        return navigationController
    }
    
    fileprivate func initTranslateController() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: DependencyContainer.resolve(TranslateController.self))
        navigationController.tabBarItem = UITabBarItem(title: "TranslateTitle".localized(),
                                                       image: .global(.translate),
                                                       selectedImage: .global(.translate))
        return navigationController
    }
    
    fileprivate func initSettingsController() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: DependencyContainer.resolve(SettingsController.self))
        navigationController.tabBarItem = UITabBarItem(title: "SettingsTitle".localized(),
                                                       image: .global(.settings),
                                                       selectedImage: .global(.settings))
        return navigationController
    }
    
    fileprivate func initAboutController() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: DependencyContainer.resolve(AboutController.self))
        navigationController.tabBarItem = UITabBarItem(title: "AboutTitle".localized(),
                                                       image: .global(.info),
                                                       selectedImage: .global(.info))
        return navigationController
    }
}
