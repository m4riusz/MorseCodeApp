//
//  RMPair.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 20/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import Foundation
import RealmSwift

final class RMPair: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var key: String?
    @objc dynamic var value: String?
    
    convenience init(key: String, value: String) {
        self.init()
        self.key = key
        self.value = value
    }
}

extension RMPair: DomainConvertibleType {
    func asDomain() -> Pair {
        return Pair(id: self.id,
                    key: self.key!,
                    value: self.value!)
    }
}

extension Pair: RealmRepresentable {
    func asRealm() -> RMPair {
        return RMPair.build { object in
            object.id = self.id
            object.key = self.key
            object.value = self.value
        }
    }
}
