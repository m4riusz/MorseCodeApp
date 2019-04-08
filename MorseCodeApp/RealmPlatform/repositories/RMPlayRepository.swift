//
//  RMPlayRepository.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 07/04/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift
import RxRealm

struct RMPlayRepository: PlayRepositoryProtocol {
    
    fileprivate static let playDefaultId: Int = 0
    fileprivate let configuration: Realm.Configuration
    fileprivate var realm: Realm {
        return try! Realm(configuration: self.configuration)
    }
    
    init(configuration: Realm.Configuration) {
        self.configuration = configuration
        //        self.createPlayTypes() // TEMPORARY
    }
    
    func setTextToPlay(_ text: String) -> Observable<Void> {
        return self.realm.rx.save(entity: Play(id: RMPlayRepository.playDefaultId,
                                               text: text),
                                  update: true)
    }
    
    func getTextToPlay() -> Observable<String> {
        let object = self.realm.objects(Play.RealmType.self)
        return Observable.changeset(from: object)
            .flatMapLatest({ items -> Observable<String> in
                return .just(items.0.first?.text ?? "")
            })
    }
    
    func selectPlayType(_ playType: PlayType) -> Observable<Void> {
        return Observable.create({ observable in
            let disposable = Disposables.create()
            self.realm.beginWrite()
            let playTypes = self.realm.objects(RMPlayType.self)
            playTypes.forEach { $0.isSelected = $0.id == playType.id}
            try! self.realm.commitWrite()
            observable.onNext(Void())
            observable.onCompleted()
            return disposable
        })
    }
    
    func getPlayTypes() -> Observable<[PlayType]> {
        let objects = self.realm.objects(PlayType.RealmType.self)
        return Observable.array(from: objects)
            .flatMapLatest { items -> Observable<[PlayType]> in
                return .just(items.map { $0.asDomain() })
        }
    }
    
    func createOrUpdatePlayType(_ playType: PlayType, update: Bool) -> Observable<Void> {
        return self.realm.rx.save(entity: playType, update: update)
    }
    
    // to remove
    func createPlayTypes() {
        let screen = PlayType(id: 1,
                              name: "Screen",
                              image: .phone,
                              isSelected: false)
        let sound = PlayType(id: 2,
                             name: "Sound",
                             image: .sound,
                             isSelected: false)
        let vibration = PlayType(id: 3,
                                 name: "Vibration",
                                 image: .vibration,
                                 isSelected: false)
        let flash = PlayType(id: 4,
                             name: "Flash",
                             image: .flash,
                             isSelected: false)
        self.createOrUpdatePlayType(screen, update: true).subscribe()
        self.createOrUpdatePlayType(sound, update: true).subscribe()
        self.createOrUpdatePlayType(vibration, update: true).subscribe()
        self.createOrUpdatePlayType(flash, update: true).subscribe()
    }
}
