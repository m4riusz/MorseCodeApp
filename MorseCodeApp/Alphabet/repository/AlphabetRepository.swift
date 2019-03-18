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

protocol AlphabetRepositoryProtocol: BaseRepositoryProtocol where T == Alphabet {
    
}

struct AlphabetRepository: AlphabetRepositoryProtocol {
    
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
}
