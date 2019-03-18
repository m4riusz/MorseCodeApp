//
//  BaseObject.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 18/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import Foundation
import RealmSwift

class BaseObject: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var createDate: Date = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
