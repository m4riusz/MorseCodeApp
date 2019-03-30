//
//  RMPlayType.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 30/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import Foundation
import RealmSwift

class RMPlayType: Object {
    @objc dynamic var id: String?
    @objc dynamic var name: String?
    @objc dynamic var image: String?
    @objc dynamic var isSelected: Bool = false
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension RMPlayType: DomainConvertibleType {
    func asDomain() -> PlayType {
        return PlayType(id: self.id!,
                        name: self.name!,
                        image: Images(rawValue: self.image!)!,
                        isSelected: self.isSelected)
    }
}

extension PlayType: RealmRepresentable {
    func asRealm() -> RMPlayType {
        return RMPlayType.build({ object in
            object.id = self.id
            object.name = self.name
            object.image = self.image.rawValue
            object.isSelected = self.isSelected
        })
    }
}
