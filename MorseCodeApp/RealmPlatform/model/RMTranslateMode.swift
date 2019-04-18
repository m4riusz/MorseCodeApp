//
//  RMTranslateMode.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 18/04/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import Foundation
import RealmSwift

final class RMTranslateMode: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var mode: Int = 0
    @objc dynamic var isSelected: Bool = false
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension RMTranslateMode: DomainConvertibleType {
    func asDomain() -> TranslateMode {
        return TranslateMode(id: self.id,
                             mode: TranslateMode.Mode(rawValue: self.mode)!,
                             isSelected: self.isSelected)
    }
}

extension TranslateMode: RealmRepresentable {
    func asRealm() -> RMTranslateMode {
        return RMTranslateMode.build({ object in
            object.id = self.id
            object.mode = self.mode.rawValue
            object.isSelected = self.isSelected
        })
    }
}

