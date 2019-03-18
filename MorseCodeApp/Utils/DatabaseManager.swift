//
//  DatabaseManager.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 18/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import Foundation
import RealmSwift

struct DatabaseManager {
    
    static let shared = DatabaseManager()
    
    fileprivate init() {}
    
    func configure(schemaVersion: UInt64) {
        var config = Realm.Configuration()
        config.schemaVersion = schemaVersion
        Realm.Configuration.defaultConfiguration = config
    }
}
