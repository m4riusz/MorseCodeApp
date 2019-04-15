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
    convenience init(text: String, textColor: UIColor, fontSize: CGFloat) {
        self.init(string: text, attributes: [.backgroundColor : textColor,
                                             .font: UIFont.systemFont(ofSize: fontSize)])
    }
    
    func all() -> NSRange {
        return NSRange(location: 0, length: self.length)
    }
}
