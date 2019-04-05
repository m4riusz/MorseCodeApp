//
//  RMAlphabet.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 20/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import Foundation
import RealmSwift

final class RMAlphabet: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var countryCode: String?
    @objc dynamic var name: String?
    @objc dynamic var isSelected: Bool = false
    let pairs = List<RMPair>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension RMAlphabet: DomainConvertibleType {
    func asDomain() -> Alphabet {
        return Alphabet(id: self.id,
                        countryCode: self.countryCode!,
                        name: self.name!,
                        pairs: self.pairs.map { $0.asDomain() },
                        isSelected: self.isSelected)
    }
}

extension Alphabet: RealmRepresentable {
    func asRealm() -> RMAlphabet {
        return RMAlphabet.build { object in
            object.id = self.id
            object.countryCode = self.countryCode
            object.name = self.name
            object.pairs.append(objectsIn: self.pairs.map { $0.asRealm() })
            object.isSelected = self.isSelected
        }
    }
}
