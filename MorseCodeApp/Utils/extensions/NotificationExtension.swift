//
//  NotificationExtension.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 16/04/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import Foundation
import UIKit

extension Notification {
    func getKeyboardHeight() -> CGFloat? {
        return (self.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
    }
    
    func getKeyboardDuration() -> Double? {
        return self.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
    }
}
