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
    func createOrUpdate(object: Alphabet) -> Single<Alphabet>
    func getByCountyCode(_ countryCode: String) -> Single<Alphabet>
    func getById(_ id: String) -> Single<Alphabet>
    func deleteById(_ id: String) -> Completable
}

struct AlphabetRepository: AlphabetRepositoryProtocol {
    
    func createMocks() {
        let alpha = Alphabet()
        alpha.countryCode = "PL"
        alpha.pairs.append(Pair(key: "A", value: "•—"))
        alpha.pairs.append(Pair(key: "Ą", value: "•—•—"))
        alpha.pairs.append(Pair(key: "B", value: "—•••"))
        alpha.pairs.append(Pair(key: "C", value: "—•—•"))
        alpha.pairs.append(Pair(key: "Ć", value: "—•—••"))
        alpha.pairs.append(Pair(key: "D", value: "—••"))
        alpha.pairs.append(Pair(key: "E", value: "•"))
        alpha.pairs.append(Pair(key: "Ę", value: "••—••"))
        alpha.pairs.append(Pair(key: "F", value: "••—•"))
        alpha.pairs.append(Pair(key: "G", value: "——•"))
        alpha.pairs.append(Pair(key: "H", value: "••••"))
        alpha.pairs.append(Pair(key: "I", value: "••"))
        alpha.pairs.append(Pair(key: "J", value: "•———"))
        alpha.pairs.append(Pair(key: "K", value: "—•—"))
        alpha.pairs.append(Pair(key: "L", value: "•—••"))
        alpha.pairs.append(Pair(key: "Ł", value: "•—••—"))
        alpha.pairs.append(Pair(key: "M", value: "——"))
        alpha.pairs.append(Pair(key: "N", value: "—•"))
        alpha.pairs.append(Pair(key: "Ń", value: "——•——"))
        alpha.pairs.append(Pair(key: "O", value: "———"))
        alpha.pairs.append(Pair(key: "Ó", value: "———•"))
        alpha.pairs.append(Pair(key: "P", value: "•——•"))
        alpha.pairs.append(Pair(key: "Q", value: "——•—"))
        alpha.pairs.append(Pair(key: "R", value: "•—•"))
        alpha.pairs.append(Pair(key: "S", value: "•••"))
        alpha.pairs.append(Pair(key: "Ś", value: "•••—•••"))
        alpha.pairs.append(Pair(key: "T", value: "—"))
        alpha.pairs.append(Pair(key: "U", value: "••—"))
        alpha.pairs.append(Pair(key: "V", value: "•••—"))
        alpha.pairs.append(Pair(key: "W", value: "•——"))
        alpha.pairs.append(Pair(key: "X", value: "—••—"))
        alpha.pairs.append(Pair(key: "Y", value: "—•——"))
        alpha.pairs.append(Pair(key: "Z", value: "——••"))
        alpha.pairs.append(Pair(key: "Ź", value: "——••—"))
        alpha.pairs.append(Pair(key: "Ż", value: "——••—•"))
        alpha.pairs.append(Pair(key: "0", value: "—————"))
        alpha.pairs.append(Pair(key: "1", value: "•————"))
        alpha.pairs.append(Pair(key: "2", value: "••———"))
        alpha.pairs.append(Pair(key: "3", value: "•••——"))
        alpha.pairs.append(Pair(key: "4", value: "••••—"))
        alpha.pairs.append(Pair(key: "5", value: "•••••"))
        alpha.pairs.append(Pair(key: "6", value: "—••••"))
        alpha.pairs.append(Pair(key: "7", value: "——•••"))
        alpha.pairs.append(Pair(key: "8", value: "———••"))
        alpha.pairs.append(Pair(key: "9", value: "————•"))
        alpha.pairs.append(Pair(key: ".", value: "•—•—•—"))
        alpha.pairs.append(Pair(key: ",", value: "——••——"))
        alpha.pairs.append(Pair(key: "'", value: "•————•"))
        alpha.pairs.append(Pair(key: "\"", value: "•—••—•"))
        alpha.pairs.append(Pair(key: "_", value: "••——•—"))
        alpha.pairs.append(Pair(key: ":", value: "———•••"))
        alpha.pairs.append(Pair(key: ";", value: "—•—•—•"))
        alpha.pairs.append(Pair(key: "?", value: "••——••"))
        alpha.pairs.append(Pair(key: "!", value: "—•—•——"))
        alpha.pairs.append(Pair(key: "-", value: "—••••—"))
        alpha.pairs.append(Pair(key: "+", value: "•—•—•"))
        alpha.pairs.append(Pair(key: "/", value: "—••—•"))
        alpha.pairs.append(Pair(key: "(", value: "—•——•"))
        alpha.pairs.append(Pair(key: ")", value: "—•——•—"))
        alpha.pairs.append(Pair(key: "=", value: "—•••—"))
        alpha.pairs.append(Pair(key: "@", value: "•——•—•"))
        
        let realm = try! Realm()
        realm.beginWrite()
        realm.create(Alphabet.self, value: alpha, update: true)
        realm.cancelWrite()
    }
    
    func createOrUpdate(object: Alphabet) -> Single<Alphabet> {
        return Single<Alphabet>.create(subscribe: { single in
            let disposable = Disposables.create()
            let realm = try! Realm()
            realm.beginWrite()
            let result = realm.create(Alphabet.self, value: object, update: true)
            realm.cancelWrite()
            single(.success(result))
            return disposable
        })
    }
    
    func getByCountyCode(_ countryCode: String) -> Single<Alphabet> {
        return Single<Alphabet>.create(subscribe: { single in
            let disposable = Disposables.create()
            let realm = try! Realm()
            guard let result = realm.objects(Alphabet.self).filter(NSPredicate(format: "countryCode == %@", countryCode)).first else {
                single(.error(NSError(description: "Not found")))
                return disposable
            }
            single(.success(result))
            return disposable
        })
    }
    
    func getById(_ id: String) -> Single<Alphabet> {
        return Single<Alphabet>.create(subscribe: { single in
            let disposable = Disposables.create()
            let realm = try! Realm()
            guard let result = realm.object(ofType: Alphabet.self, forPrimaryKey: id) else {
                single(.error(NSError(description: "Not found")))
                return disposable
            }
            single(.success(result))
            return disposable
        })
    }
    
    func deleteById(_ id: String) -> Completable {
        return Completable.create(subscribe: { completable in
            let disposable = Disposables.create()
            let realm = try! Realm()
            guard let result = realm.object(ofType: Alphabet.self, forPrimaryKey: id) else {
                completable(.error(NSError(description: "Not found")))
                return disposable
            }
            return disposable
        })
    }
}
