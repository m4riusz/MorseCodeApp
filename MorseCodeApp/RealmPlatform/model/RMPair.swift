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
    @objc dynamic var id: Int = 0
    @objc dynamic var key: String?
    @objc dynamic var value: String?
    @objc dynamic var isVisible: Bool = true
    @objc dynamic var color: String?
    
    convenience init(key: String, value: String, isVisible: Bool = true, color: UIColor) {
        self.init()
        self.key = key
        self.value = value
        self.isVisible = isVisible
        self.color = color.hexString
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension RMPair: DomainConvertibleType {
    func asDomain() -> Pair {
        return Pair(id: self.id,
                    key: self.key!,
                    value: self.value!,
                    isVisible: self.isVisible,
                    color: UIColor(hexString: self.color!)!)
    }
}

extension Pair: RealmRepresentable {
    func asRealm() -> RMPair {
        return RMPair.build { object in
            object.id = self.id
            object.key = self.key
            object.value = self.value
            object.isVisible = self.isVisible
            object.color = self.color.hexString
        }
    }
}
