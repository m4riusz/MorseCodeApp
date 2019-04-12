//
//  NSAttributedString.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 12/04/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import Foundation
import UIKit

extension NSAttributedString {
    convenience init(text: String, textColor: UIColor) {
        self.init(string: text, attributes: [NSAttributedString.Key.backgroundColor : textColor,
                                             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
    }
}
