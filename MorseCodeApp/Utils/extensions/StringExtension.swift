//
//  StringExtension.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 24/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
