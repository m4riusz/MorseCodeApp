//
//  RMPlay.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 03/04/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import Foundation
import RealmSwift

final class RMPlay: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var text: String?
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension RMPlay: DomainConvertibleType {
    func asDomain() -> Play {
        return Play(id: self.id,
                    text: self.text!)
    }
}

extension Play: RealmRepresentable {
    func asRealm() -> RMPlay {
        return RMPlay.build({ item in
            item.id = self.id
            item.text = self.text
        })
    }
}
