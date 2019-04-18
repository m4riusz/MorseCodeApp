//
//  RMAlphabetRepository.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 07/04/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

struct RMAlphabetRepository: AlphabetRepositoryProtocol {
    fileprivate let configuration: Realm.Configuration
    fileprivate var realm: Realm {
        return try! Realm(configuration: self.configuration)
    }
    
    init(configuration: Realm.Configuration) {
        self.configuration = configuration
    }
    
    func select(_ alphabet: Alphabet) -> Completable {
        return Completable.create(subscribe: { completable in
            let disposable = Disposables.create()
            self.realm.beginWrite()
            let alphabets = self.realm.objects(Alphabet.RealmType.self)
            alphabets.forEach { $0.isSelected = $0.id == alphabet.id }
            try! self.realm.commitWrite()
            completable(.completed)
            return disposable
        })
    }
    
    func createOrUpdate(_ alphabet: Alphabet, update: Bool) -> Observable<Void> {
        return self.realm.rx.save(entity: alphabet, update: update)
    }
    
    func getAll() -> Observable<[Alphabet]> {
        let objects = self.realm.objects(Alphabet.RealmType.self)
        return Observable.array(from: objects)
            .flatMapLatest { items -> Observable<[Alphabet]> in
                return .just(items.map { $0.asDomain() })
        }
    }
    
     func reset() {
        let polishPairs = [Pair(id: 100, key: "A", value: "•—", isVisible: true),
                           Pair(id: 101, key: "Ą", value: "•—•—", isVisible: true),
                           Pair(id: 102, key: "B", value: "—•••", isVisible: true),
                           Pair(id: 103, key: "C", value: "—•—•", isVisible: true),
                           Pair(id: 104, key: "Ć", value: "—•—••", isVisible: true),
                           Pair(id: 105, key: "D", value: "—••", isVisible: true),
                           Pair(id: 106, key: "E", value: "•", isVisible: true),
                           Pair(id: 107, key: "Ę", value: "••—••", isVisible: true),
                           Pair(id: 108, key: "F", value: "••—•", isVisible: true),
                           Pair(id: 109, key: "G", value: "——•", isVisible: true),
                           Pair(id: 110, key: "H", value: "••••", isVisible: true),
                           Pair(id: 111, key: "I", value: "••", isVisible: true),
                           Pair(id: 112, key: "J", value: "•———", isVisible: true),
                           Pair(id: 113, key: "K", value: "—•—", isVisible: true),
                           Pair(id: 114, key: "L", value: "•—••", isVisible: true),
                           Pair(id: 115, key: "Ł", value: "•—••—", isVisible: true),
                           Pair(id: 116, key: "M", value: "——", isVisible: true),
                           Pair(id: 117, key: "N", value: "—•", isVisible: true),
                           Pair(id: 118, key: "Ń", value: "——•——", isVisible: true),
                           Pair(id: 119, key: "O", value: "———", isVisible: true),
                           Pair(id: 120, key: "Ó", value: "———•", isVisible: true),
                           Pair(id: 121, key: "P", value: "•——•", isVisible: true),
                           Pair(id: 122, key: "Q", value: "——•—", isVisible: true),
                           Pair(id: 123, key: "R", value: "•—•", isVisible: true),
                           Pair(id: 124, key: "S", value: "•••", isVisible: true),
                           Pair(id: 125, key: "Ś", value: "•••—•••", isVisible: true),
                           Pair(id: 126, key: "T", value: "—", isVisible: true),
                           Pair(id: 127, key: "U", value: "••—", isVisible: true),
                           Pair(id: 128, key: "V", value: "•••—", isVisible: true),
                           Pair(id: 129, key: "W", value: "•——", isVisible: true),
                           Pair(id: 130, key: "X", value: "—••—", isVisible: true),
                           Pair(id: 131, key: "Y", value: "—•——", isVisible: true),
                           Pair(id: 132, key: "Z", value: "——••", isVisible: true),
                           Pair(id: 133, key: "Ź", value: "——••—", isVisible: true),
                           Pair(id: 134, key: "Ż", value: "——••—•", isVisible: true),
                           Pair(id: 135, key: "0", value: "—————", isVisible: true),
                           Pair(id: 136, key: "1", value: "•————", isVisible: true),
                           Pair(id: 137, key: "2", value: "••———", isVisible: true),
                           Pair(id: 138, key: "3", value: "•••——", isVisible: true),
                           Pair(id: 139, key: "4", value: "••••—", isVisible: true),
                           Pair(id: 140, key: "5", value: "•••••", isVisible: true),
                           Pair(id: 141, key: "6", value: "—••••", isVisible: true),
                           Pair(id: 142, key: "7", value: "——•••", isVisible: true),
                           Pair(id: 143, key: "8", value: "———••", isVisible: true),
                           Pair(id: 144, key: "9", value: "————•", isVisible: true),
                           Pair(id: 145, key: ".", value: "•—•—•—", isVisible: true),
                           Pair(id: 146, key: ",", value: "——••——", isVisible: true),
                           Pair(id: 147, key: "'", value: "•————•", isVisible: true),
                           Pair(id: 148, key: "\"", value: "•—••—•", isVisible: true),
                           Pair(id: 149, key: "_", value: "••——•—", isVisible: true),
                           Pair(id: 150, key: ":", value: "———•••", isVisible: true),
                           Pair(id: 151, key: ";", value: "—•—•—•", isVisible: true),
                           Pair(id: 152, key: "?", value: "••——••", isVisible: true),
                           Pair(id: 153, key: "!", value: "—•—•——", isVisible: true),
                           Pair(id: 154, key: "-", value: "—••••—", isVisible: true),
                           Pair(id: 155, key: "+", value: "•—•—•", isVisible: true),
                           Pair(id: 156, key: "/", value: "—••—•", isVisible: true),
                           Pair(id: 157, key: "(", value: "—•——•", isVisible: true),
                           Pair(id: 158, key: ")", value: "—•——•—", isVisible: true),
                           Pair(id: 159, key: "=", value: "—•••—", isVisible: true),
                           Pair(id: 160, key: "@", value: "•——•—•", isVisible: true),
                           Pair(id: 170, key: " ", value: " ", isVisible: false)
        ]
        let engilshPairs = [Pair(id: 301, key: "A", value: "•—", isVisible: true),
                            Pair(id: 302, key: "B", value: "—•••", isVisible: true),
                            Pair(id: 303, key: "C", value: "—•—•", isVisible: true),
                            Pair(id: 305, key: "D", value: "—••", isVisible: true),
                            Pair(id: 306, key: "E", value: "•", isVisible: true),
                            Pair(id: 308, key: "F", value: "••—•", isVisible: true),
                            Pair(id: 309, key: "G", value: "——•", isVisible: true),
                            Pair(id: 310, key: "H", value: "••••", isVisible: true),
                            Pair(id: 311, key: "I", value: "••", isVisible: true),
                            Pair(id: 312, key: "J", value: "•———", isVisible: true),
                            Pair(id: 313, key: "K", value: "—•—", isVisible: true),
                            Pair(id: 314, key: "L", value: "•—••", isVisible: true),
                            Pair(id: 316, key: "M", value: "——", isVisible: true),
                            Pair(id: 317, key: "N", value: "—•", isVisible: true),
                            Pair(id: 319, key: "O", value: "———", isVisible: true),
                            Pair(id: 321, key: "P", value: "•——•", isVisible: true),
                            Pair(id: 322, key: "Q", value: "——•—", isVisible: true),
                            Pair(id: 323, key: "R", value: "•—•", isVisible: true),
                            Pair(id: 324, key: "S", value: "•••", isVisible: true),
                            Pair(id: 326, key: "T", value: "—", isVisible: true),
                            Pair(id: 327, key: "U", value: "••—", isVisible: true),
                            Pair(id: 328, key: "V", value: "•••—", isVisible: true),
                            Pair(id: 329, key: "W", value: "•——", isVisible: true),
                            Pair(id: 330, key: "X", value: "—••—", isVisible: true),
                            Pair(id: 331, key: "Y", value: "—•——", isVisible: true),
                            Pair(id: 332, key: "Z", value: "——••", isVisible: true),
                            Pair(id: 335, key: "0", value: "—————", isVisible: true),
                            Pair(id: 336, key: "1", value: "•————", isVisible: true),
                            Pair(id: 337, key: "2", value: "••———", isVisible: true),
                            Pair(id: 338, key: "3", value: "•••——", isVisible: true),
                            Pair(id: 339, key: "4", value: "••••—", isVisible: true),
                            Pair(id: 340, key: "5", value: "•••••", isVisible: true),
                            Pair(id: 341, key: "6", value: "—••••", isVisible: true),
                            Pair(id: 342, key: "7", value: "——•••", isVisible: true),
                            Pair(id: 343, key: "8", value: "———••", isVisible: true),
                            Pair(id: 344, key: "9", value: "————•", isVisible: true),
                            Pair(id: 345, key: ".", value: "•—•—•—", isVisible: true),
                            Pair(id: 346, key: ",", value: "——••——", isVisible: true),
                            Pair(id: 347, key: "'", value: "•————•", isVisible: true),
                            Pair(id: 348, key: "\"", value: "•—••—•", isVisible: true),
                            Pair(id: 349, key: "_", value: "••——•—", isVisible: true),
                            Pair(id: 350, key: ":", value: "———•••", isVisible: true),
                            Pair(id: 351, key: ";", value: "—•—•—•", isVisible: true),
                            Pair(id: 352, key: "?", value: "••——••", isVisible: true),
                            Pair(id: 353, key: "!", value: "—•—•——", isVisible: true),
                            Pair(id: 354, key: "-", value: "—••••—", isVisible: true),
                            Pair(id: 355, key: "+", value: "•—•—•", isVisible: true),
                            Pair(id: 356, key: "/", value: "—••—•", isVisible: true),
                            Pair(id: 357, key: "(", value: "—•——•", isVisible: true),
                            Pair(id: 358, key: ")", value: "—•——•—", isVisible: true),
                            Pair(id: 359, key: "=", value: "—•••—", isVisible: true),
                            Pair(id: 360, key: "@", value: "•——•—•", isVisible: true),
                            Pair(id: 370, key: " ", value: " ", isVisible: false)
        ]
        let alphabetsObjects = self.realm.objects(Alphabet.RealmType.self)
        let pairsObjects = self.realm.objects(Pair.RealmType.self)
        let polishAlphabet = Alphabet(id: 1, countryCode: "PL", name: "Polski", pairs: polishPairs, isSelected: false)
        let englishAlphabet = Alphabet(id: 2, countryCode: "GB", name: "English", pairs: engilshPairs, isSelected: false)
        self.realm.beginWrite()
        self.realm.delete(alphabetsObjects)
        self.realm.delete(pairsObjects)
        self.realm.add(polishAlphabet.asRealm())
        self.realm.add(englishAlphabet.asRealm())
        try! self.realm.commitWrite()
        
        
     }
     
    func getAll(with predicate: NSPredicate) -> Observable<[Alphabet]> {
        let objects = self.realm.objects(Alphabet.RealmType.self).filter(predicate)
        return Observable.array(from: objects).flatMapLatest({ realm -> Observable<[Alphabet]> in
            return .just(realm.map { $0.asDomain() })
        })
    }
    
    func delete(_ alphabet: Alphabet) -> Observable<Void> {
        return self.realm.rx.delete(entity: alphabet)
    }
}
