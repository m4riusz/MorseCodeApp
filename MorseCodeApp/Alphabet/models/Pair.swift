//
//  Pair.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 18/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import Foundation
import UIKit

struct Pair {
    let id: Int
    let key: String
    let value: String
    let isVisible: Bool
}

extension Pair {
    static let dividerSymbol: Character = "​" // value is unicode U+200B
    fileprivate static let dividerId: Int = 2000
    
    static func divider() -> Pair {
        return Pair(id: Pair.dividerId,
                    key: "​",
                    value: String(Pair.dividerSymbol),
                    isVisible: false)
    }
    
    func isDivider() -> Bool {
        return self.id == Pair.dividerId
    }
}
