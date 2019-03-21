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
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var countryCode: String?
    let pairs = List<RMPair>()
}

extension RMAlphabet: DomainConvertibleType {
    func asDomain() -> Alphabet {
        return Alphabet(id: self.id,
                        countryCode: self.countryCode ?? "",
                        pairs: self.pairs.map { $0.asDomain() })
    }
}

extension Alphabet: RealmRepresentable {
    func asRealm() -> RMAlphabet {
        return RMAlphabet.build { object in
            object.id = self.id
            object.pairs.append(objectsIn: self.pairs.map { $0.asRealm() })
        }
    }
}
