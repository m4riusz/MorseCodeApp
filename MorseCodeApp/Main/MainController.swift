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
    }
    
    fileprivate func initAlphabetController() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: AlphabetController())
        return navigationController
    }
}
