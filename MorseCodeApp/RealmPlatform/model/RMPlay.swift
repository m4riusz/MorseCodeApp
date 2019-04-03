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
    @objc dynamic var id: String?
    @objc dynamic var morseCode: String?
    @objc dynamic var text: String?
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension Play: RealmRepresentable {
    func asRealm() -> RMPlay {
        return RMPlay.build({ item in
            item.id = self.id
            item.morseCode = self.morseCode
            item.text = self.text
        })
    }
}

extension RMPlay: DomainConvertibleType {
    func asDomain() -> Play {
        return Play(id: self.id!,
                    morseCode: self.morseCode!,
                    text: self.text!)
    }
}
