//
//  PlayTypeRepository.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 30/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

protocol PlayTypeRepositoryProtocol {
    func select(_ playType: PlayType) -> Completable
    func createOrUpdate(_ playType: PlayType, update: Bool) -> Observable<Void>
    func getAll() -> Observable<[PlayType]>
}

struct PlayTypeRepository: PlayTypeRepositoryProtocol {

    fileprivate let configuration: Realm.Configuration
    fileprivate var realm: Realm {
        return try! Realm(configuration: self.configuration)
    }
    
    init(configuration: Realm.Configuration) {
        self.configuration = configuration
//        self.createPlayTypes() // TEMPORARY
    }
    
    func select(_ playType: PlayType) -> Completable {
        return Completable.create(subscribe: { completable in
            let disposable = Disposables.create()
            self.realm.beginWrite()
            let playTypes = self.realm.objects(RMPlayType.self)
            playTypes.forEach { $0.isSelected = $0.id == playType.id}
            try! self.realm.commitWrite()
            completable(.completed)
            return disposable
        })
    }
    
    func getAll() -> Observable<[PlayType]> {
        let objects = self.realm.objects(PlayType.RealmType.self)
        return Observable.array(from: objects)
            .flatMapLatest { items -> Observable<[PlayType]> in
                return .just(items.map { $0.asDomain() })
        }
    }
    
    func createOrUpdate(_ playType: PlayType, update: Bool) -> Observable<Void> {
        return self.realm.rx.save(entity: playType, update: update)
    }
    
    // to remove
    func createPlayTypes() {
        let screen = PlayType(id: "1",
                              name: "Screen",
                              image: .phone,
                              isSelected: false)
        let sound = PlayType(id: "2",
                             name: "Sound",
                             image: .sound,
                             isSelected: false)
        let vibration = PlayType(id: "3",
                                 name: "Vibration",
                                 image: .vibration,
                                 isSelected: false)
        let flash = PlayType(id: "4",
                             name: "Flash",
                             image: .flash,
                             isSelected: false)
        self.createOrUpdate(screen, update: true).subscribe()
        self.createOrUpdate(sound, update: true).subscribe()
        self.createOrUpdate(vibration, update: true).subscribe()
        self.createOrUpdate(flash, update: true).subscribe()
    }
}
