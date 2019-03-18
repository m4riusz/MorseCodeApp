//
//  NSErrorExtension.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 18/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import Foundation

extension NSError {
    
    convenience init(description: String) {
        self.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: description])
    }
}
