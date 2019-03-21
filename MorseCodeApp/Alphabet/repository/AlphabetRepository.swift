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
        let objects = self.realm.objects(Alphabet.RealmType.self)
        return Observable.array(from: objects).flatMapLatest({ realm -> Observable<[Alphabet]> in
            return .just(realm.map { $0.asDomain() })
        })
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
