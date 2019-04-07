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
        //        self.createAlphabets() // TEMPRORARY
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
    /*
     func createAlphabets() {
     let polishPairs: [Pair] = [Pair(id: 100, key: "A", value: "•—"),
     Pair(id: 101, key: "Ą", value: "•—•—"),
     Pair(id: 102, key: "B", value: "—•••"),
     Pair(id: 103, key: "C", value: "—•—•"),
     Pair(id: 104, key: "Ć", value: "—•—••"),
     Pair(id: 105, key: "D", value: "—••"),
     Pair(id: 106, key: "E", value: "•"),
     Pair(id: 107, key: "Ę", value: "••—••"),
     Pair(id: 108, key: "F", value: "••—•"),
     Pair(id: 109, key: "G", value: "——•"),
     Pair(id: 110, key: "H", value: "••••"),
     Pair(id: 111, key: "I", value: "••"),
     Pair(id: 112, key: "J", value: "•———"),
     Pair(id: 113, key: "K", value: "—•—"),
     Pair(id: 114, key: "L", value: "•—••"),
     Pair(id: 115, key: "Ł", value: "•—••—"),
     Pair(id: 116, key: "M", value: "——"),
     Pair(id: 117, key: "N", value: "—•"),
     Pair(id: 118, key: "Ń", value: "——•——"),
     Pair(id: 119, key: "O", value: "———"),
     Pair(id: 120, key: "Ó", value: "———•"),
     Pair(id: 121, key: "P", value: "•——•"),
     Pair(id: 122, key: "Q", value: "——•—"),
     Pair(id: 123, key: "R", value: "•—•"),
     Pair(id: 124, key: "S", value: "•••"),
     Pair(id: 125, key: "Ś", value: "•••—•••"),
     Pair(id: 126, key: "T", value: "—"),
     Pair(id: 127, key: "U", value: "••—"),
     Pair(id: 128, key: "V", value: "•••—"),
     Pair(id: 129, key: "W", value: "•——"),
     Pair(id: 130, key: "X", value: "—••—"),
     Pair(id: 131, key: "Y", value: "—•——"),
     Pair(id: 132, key: "Z", value: "——••"),
     Pair(id: 133, key: "Ź", value: "——••—"),
     Pair(id: 134, key: "Ż", value: "——••—•"),
     Pair(id: 135, key: "0", value: "—————"),
     Pair(id: 136, key: "1", value: "•————"),
     Pair(id: 137, key: "2", value: "••———"),
     Pair(id: 138, key: "3", value: "•••——"),
     Pair(id: 139, key: "4", value: "••••—"),
     Pair(id: 140, key: "5", value: "•••••"),
     Pair(id: 141, key: "6", value: "—••••"),
     Pair(id: 142, key: "7", value: "——•••"),
     Pair(id: 143, key: "8", value: "———••"),
     Pair(id: 144, key: "9", value: "————•"),
     Pair(id: 145, key: ".", value: "•—•—•—"),
     Pair(id: 146, key: ",", value: "——••——"),
     Pair(id: 147, key: "'", value: "•————•"),
     Pair(id: 148, key: "\"", value: "•—••—•"),
     Pair(id: 149, key: "_", value: "••——•—"),
     Pair(id: 150, key: ":", value: "———•••"),
     Pair(id: 151, key: ";", value: "—•—•—•"),
     Pair(id: 152, key: "?", value: "••——••"),
     Pair(id: 153, key: "!", value: "—•—•——"),
     Pair(id: 154, key: "-", value: "—••••—"),
     Pair(id: 155, key: "+", value: "•—•—•"),
     Pair(id: 156, key: "/", value: "—••—•"),
     Pair(id: 157, key: "(", value: "—•——•"),
     Pair(id: 158, key: ")", value: "—•——•—"),
     Pair(id: 159, key: "=", value: "—•••—"),
     Pair(id: 160, key: "@", value: "•——•—•")
     ]
     let polishAlphabet = Alphabet(id: 1, countryCode: "PL", name: "Polski", pairs: polishPairs, isSelected: false)
     
     
     let engilshPairs: [Pair] = [Pair(id: 100, key: "A", value: "•—"),
     Pair(id: 102, key: "B", value: "—•••"),
     Pair(id: 103, key: "C", value: "—•—•"),
     Pair(id: 105, key: "D", value: "—••"),
     Pair(id: 106, key: "E", value: "•"),
     Pair(id: 108, key: "F", value: "••—•"),
     Pair(id: 109, key: "G", value: "——•"),
     Pair(id: 110, key: "H", value: "••••"),
     Pair(id: 111, key: "I", value: "••"),
     Pair(id: 112, key: "J", value: "•———"),
     Pair(id: 113, key: "K", value: "—•—"),
     Pair(id: 114, key: "L", value: "•—••"),
     Pair(id: 116, key: "M", value: "——"),
     Pair(id: 117, key: "N", value: "—•"),
     Pair(id: 119, key: "O", value: "———"),
     Pair(id: 121, key: "P", value: "•——•"),
     Pair(id: 122, key: "Q", value: "——•—"),
     Pair(id: 123, key: "R", value: "•—•"),
     Pair(id: 124, key: "S", value: "•••"),
     Pair(id: 126, key: "T", value: "—"),
     Pair(id: 127, key: "U", value: "••—"),
     Pair(id: 128, key: "V", value: "•••—"),
     Pair(id: 129, key: "W", value: "•——"),
     Pair(id: 130, key: "X", value: "—••—"),
     Pair(id: 131, key: "Y", value: "—•——"),
     Pair(id: 132, key: "Z", value: "——••"),
     Pair(id: 135, key: "0", value: "—————"),
     Pair(id: 136, key: "1", value: "•————"),
     Pair(id: 137, key: "2", value: "••———"),
     Pair(id: 138, key: "3", value: "•••——"),
     Pair(id: 139, key: "4", value: "••••—"),
     Pair(id: 140, key: "5", value: "•••••"),
     Pair(id: 141, key: "6", value: "—••••"),
     Pair(id: 142, key: "7", value: "——•••"),
     Pair(id: 143, key: "8", value: "———••"),
     Pair(id: 144, key: "9", value: "————•"),
     Pair(id: 145, key: ".", value: "•—•—•—"),
     Pair(id: 146, key: ",", value: "——••——"),
     Pair(id: 147, key: "'", value: "•————•"),
     Pair(id: 148, key: "\"", value: "•—••—•"),
     Pair(id: 149, key: "_", value: "••——•—"),
     Pair(id: 150, key: ":", value: "———•••"),
     Pair(id: 151, key: ";", value: "—•—•—•"),
     Pair(id: 152, key: "?", value: "••——••"),
     Pair(id: 153, key: "!", value: "—•—•——"),
     Pair(id: 154, key: "-", value: "—••••—"),
     Pair(id: 155, key: "+", value: "•—•—•"),
     Pair(id: 156, key: "/", value: "—••—•"),
     Pair(id: 157, key: "(", value: "—•——•"),
     Pair(id: 158, key: ")", value: "—•——•—"),
     Pair(id: 159, key: "=", value: "—•••—"),
     Pair(id: 160, key: "@", value: "•——•—•")
     ]
     let englishAlphabet = Alphabet(id: 2, countryCode: "GB", name: "English", pairs: engilshPairs, isSelected: false)
     
     self.createOrUpdate(englishAlphabet, update: true).subscribe()
     self.createOrUpdate(polishAlphabet, update: true).subscribe()
     }
     */
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