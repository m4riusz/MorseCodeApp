//
//  Alphabet.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 18/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import Foundation
import RealmSwift

class Alphabet: BaseObject {
    @objc dynamic var countryCode: String?
    let pairs = List<Pair>()
}
