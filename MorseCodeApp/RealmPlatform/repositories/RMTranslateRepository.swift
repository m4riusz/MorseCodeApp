//
//  RMTranslateRepository.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 18/04/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

struct RMTranslateRepository: TranslateRepositoryProtocol {

    fileprivate let configuration: Realm.Configuration
    fileprivate var realm: Realm {
        return try! Realm(configuration: self.configuration)
    }
    
    init(configuration: Realm.Configuration) {
        self.configuration = configuration
    }
    
    func select(_ translateMode: TranslateMode) -> Observable<Void> {
        return Observable.create({ observable in
            let allObjects = self.realm.objects(TranslateMode.RealmType.self)
            self.realm.beginWrite()
            allObjects.forEach { $0.isSelected = $0.id == translateMode.id }
            try! self.realm.commitWrite()
            observable.onNext(Void())
            observable.onCompleted()
            return Disposables.create()
        })
    }
    
    func getAll() -> Observable<[TranslateMode]> {
        let objects = self.realm.objects(TranslateMode.RealmType.self)
        return Observable.array(from: objects)
            .flatMapLatest { items -> Observable<[TranslateMode]> in
                return .just(items.map { $0.asDomain() })
        }
    }
    
    func reset() {
        let textToMorse = TranslateMode(id: 0, mode: .textToMorse, isSelected: true)
        let morseToCode = TranslateMode(id: 1, mode: .morseToText, isSelected: false)
        
        self.realm.beginWrite()
        let objects = self.realm.objects(TranslateMode.RealmType.self)
        self.realm.delete(objects)
        self.realm.add(textToMorse.asRealm())
        self.realm.add(morseToCode.asRealm())
        try! self.realm.commitWrite()
    }
}
