//
//  UIImageExtension.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 17/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import UIKit

extension UIImage {
    class func global(_ image: Images) -> UIImage {
        return UIImage(named: image.rawValue)!.withRenderingMode(.alwaysTemplate)
    }
}
