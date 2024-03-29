//
//  Alphabet.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 18/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import Foundation

struct Alphabet {
    let id: Int
    let countryCode: String
    let name: String
    let pairs: [Pair]
    let isSelected: Bool
}
