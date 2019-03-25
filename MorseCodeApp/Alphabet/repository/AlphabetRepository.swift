//
//  AlphabetRepository.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 18/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

protocol AlphabetRepositoryProtocol {
    func createOrUpdate(entity: Alphabet, update: Bool) -> Observable<Void>
    func queryAll() -> Observable<[Alphabet]>
    func query(with predicate: NSPredicate) -> Observable<[Alphabet]>
    func delete(entity: Alphabet) -> Observable<Void>
}

struct AlphabetRepository: AlphabetRepositoryProtocol {
    fileprivate let configuration: Realm.Configuration
    fileprivate var realm: Realm {
        return try! Realm(configuration: self.configuration)
    }
    
    init(configuration: Realm.Configuration) {
        self.configuration = configuration
    }
    
    func createOrUpdate(entity: Alphabet, update: Bool) -> Observable<Void> {
        return self.realm.rx.save(entity: entity, update: update)
    }
    
    func queryAll() -> Observable<[Alphabet]> {
//
//        let objects = self.realm.objects(Alphabet.RealmType.self)
//        return Observable.array(from: objects).flatMapLatest({ realm -> Observable<[Alphabet]> in
//            return .just(realm.map { $0.asDomain() })
//        })
        let al1 = Alphabet(id: "1",
                           countryCode: "PL",
                           pairs: [
                            Pair(id: "11", key: "A", value: "-.--."),
                            Pair(id: "12", key: "B", value: "-.."),
                            Pair(id: "13", key: "C", value: ".--."),
                            Pair(id: "14", key: "D", value: "--."),
                            Pair(id: "15", key: "E", value: "-."),
                            Pair(id: "16", key: "F", value: ".--."),
                            Pair(id: "17", key: "G", value: "-.-"),
                            Pair(id: "18", key: "H", value: "--."),
                            Pair(id: "19", key: "I", value: ".."),
                            Pair(id: "20", key: "J", value: ".")
            ], isSelected: true)
        
        let al2 = Alphabet(id: "2",
                           countryCode: "ENNNNN",
                           pairs: [
                            Pair(id: "21", key: "A", value: ".-."),
                            Pair(id: "22", key: "B", value: ".."),
                            Pair(id: "23", key: "C", value: "-."),
                            Pair(id: "24", key: "D", value: "-."),
                            Pair(id: "25", key: "E", value: "-."),
                            Pair(id: "26", key: "F", value: ".-."),
                            Pair(id: "27", key: "G", value: "-."),
                            Pair(id: "28", key: "H", value: "-..."),
                            Pair(id: "29", key: "I", value: ".----."),
                            Pair(id: "30", key: "J", value: "-")
            ], isSelected: false)
        
        return .just([al1, al2])
    }
    
    func query(with predicate: NSPredicate) -> Observable<[Alphabet]> {
        let objects = self.realm.objects(Alphabet.RealmType.self).filter(predicate)
        return Observable.array(from: objects).flatMapLatest({ realm -> Observable<[Alphabet]> in
            return .just(realm.map { $0.asDomain() })
        })
    }
    
    func delete(entity: Alphabet) -> Observable<Void> {
        return self.realm.rx.delete(entity: entity)
    }
}
