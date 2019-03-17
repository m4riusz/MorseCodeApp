//
//  UIColorExtension.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 17/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import UIKit
import SwifterSwift

extension UIColor {
    class func global(_ color: Colors) -> UIColor {
        return UIColor.init(named: color.rawValue)!
    }
}
