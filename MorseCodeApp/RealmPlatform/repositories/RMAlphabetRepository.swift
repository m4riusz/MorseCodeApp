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
//        self.createAlphabets()
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
    
     func createAlphabets() {
        let polishPairs = [Pair(id: 100, key: "A", value: "•—", isVisible: true, color: UIColor(hexString: "#FAC7FF")!),
                           Pair(id: 101, key: "Ą", value: "•—•—", isVisible: true, color: UIColor(hexString: "#FFCF94")!),
                           Pair(id: 102, key: "B", value: "—•••", isVisible: true, color: UIColor(hexString: "#FFEBC2")!),
                           Pair(id: 103, key: "C", value: "—•—•", isVisible: true, color: UIColor(hexString: "#B3DBFF")!),
                           Pair(id: 104, key: "Ć", value: "—•—••", isVisible: true, color: UIColor(hexString: "#CF99FF")!),
                           Pair(id: 105, key: "D", value: "—••", isVisible: true, color: UIColor(hexString: "#FFA199")!),
                           Pair(id: 106, key: "E", value: "•", isVisible: true, color: UIColor(hexString: "#FDFFCC")!),
                           Pair(id: 107, key: "Ę", value: "••—••", isVisible: true, color: UIColor(hexString: "#85F2FF")!),
                           Pair(id: 108, key: "F", value: "••—•", isVisible: true, color: UIColor(hexString: "#B7FFA3")!),
                           Pair(id: 109, key: "G", value: "——•", isVisible: true, color: UIColor(hexString: "#9ECAFF")!),
                           Pair(id: 110, key: "H", value: "••••", isVisible: true, color: UIColor(hexString: "#F3FF8A")!),
                           Pair(id: 111, key: "I", value: "••", isVisible: true, color: UIColor(hexString: "#B280FF")!),
                           Pair(id: 112, key: "J", value: "•———", isVisible: true, color: UIColor(hexString: "#8FADFF")!),
                           Pair(id: 113, key: "K", value: "—•—", isVisible: true, color: UIColor(hexString: "#C7E7FF")!),
                           Pair(id: 114, key: "L", value: "•—••", isVisible: true, color: UIColor(hexString: "#FFCEB3")!),
                           Pair(id: 115, key: "Ł", value: "•—••—", isVisible: true, color: UIColor(hexString: "#E5C7FF")!),
                           Pair(id: 116, key: "M", value: "——", isVisible: true, color: UIColor(hexString: "#FFDB99")!),
                           Pair(id: 117, key: "N", value: "—•", isVisible: true, color: UIColor(hexString: "#A7FF8F")!),
                           Pair(id: 118, key: "Ń", value: "——•——", isVisible: true, color: UIColor(hexString: "#FFD994")!),
                           Pair(id: 119, key: "O", value: "———", isVisible: true, color: UIColor(hexString: "#97FF8F")!),
                           Pair(id: 120, key: "Ó", value: "———•", isVisible: true, color: UIColor(hexString: "#B8F0FF")!),
                           Pair(id: 121, key: "P", value: "•——•", isVisible: true, color: UIColor(hexString: "#CE80FF")!),
                           Pair(id: 122, key: "Q", value: "——•—", isVisible: true, color: UIColor(hexString: "#FFA39E")!),
                           Pair(id: 123, key: "R", value: "•—•", isVisible: true, color: UIColor(hexString: "#A3C2FF")!),
                           Pair(id: 124, key: "S", value: "•••", isVisible: true, color: UIColor(hexString: "#FFAEFA")!),
                           Pair(id: 125, key: "Ś", value: "•••—•••", isVisible: true, color: UIColor(hexString: "#E480FF")!),
                           Pair(id: 126, key: "T", value: "—", isVisible: true, color: UIColor(hexString: "#BDFFB8")!),
                           Pair(id: 127, key: "U", value: "••—", isVisible: true, color: UIColor(hexString: "#A3C0FF")!),
                           Pair(id: 128, key: "V", value: "•••—", isVisible: true, color: UIColor(hexString: "#E1FF80")!),
                           Pair(id: 129, key: "W", value: "•——", isVisible: true, color: UIColor(hexString: "#E4FFA3")!),
                           Pair(id: 130, key: "X", value: "—••—", isVisible: true, color: UIColor(hexString: "#FFE0B8")!),
                           Pair(id: 131, key: "Y", value: "—•——", isVisible: true, color: UIColor(hexString: "#D1FFAE")!),
                           Pair(id: 132, key: "Z", value: "——••", isVisible: true, color: UIColor(hexString: "#FFC2FD")!),
                           Pair(id: 133, key: "Ź", value: "——••—", isVisible: true, color: UIColor(hexString: "#8097FF")!),
                           Pair(id: 134, key: "Ż", value: "——••—•", isVisible: true, color: UIColor(hexString: "#E3BDFF")!),
                           Pair(id: 135, key: "0", value: "—————", isVisible: true, color: UIColor(hexString: "#AEFFB4")!),
                           Pair(id: 136, key: "1", value: "•————", isVisible: true, color: UIColor(hexString: "#AEAFFF")!),
                           Pair(id: 137, key: "2", value: "••———", isVisible: true, color: UIColor(hexString: "#FFFFC7")!),
                           Pair(id: 138, key: "3", value: "•••——", isVisible: true, color: UIColor(hexString: "#F6FFC2")!),
                           Pair(id: 139, key: "4", value: "••••—", isVisible: true, color: UIColor(hexString: "#B7AEFF")!),
                           Pair(id: 140, key: "5", value: "•••••", isVisible: true, color: UIColor(hexString: "#A8FF85")!),
                           Pair(id: 141, key: "6", value: "—••••", isVisible: true, color: UIColor(hexString: "#FFE880")!),
                           Pair(id: 142, key: "7", value: "——•••", isVisible: true, color: UIColor(hexString: "#FFAEBD")!),
                           Pair(id: 143, key: "8", value: "———••", isVisible: true, color: UIColor(hexString: "#FFCCE8")!),
                           Pair(id: 144, key: "9", value: "————•", isVisible: true, color: UIColor(hexString: "#DEC2FF")!),
                           Pair(id: 145, key: ".", value: "•—•—•—", isVisible: true, color: UIColor(hexString: "#AEDDFF")!),
                           Pair(id: 146, key: ",", value: "——••——", isVisible: true, color: UIColor(hexString: "#FF80D9")!),
                           Pair(id: 147, key: "'", value: "•————•", isVisible: true, color: UIColor(hexString: "#FFC3C2")!),
                           Pair(id: 148, key: "\"", value: "•—••—•", isVisible: true, color: UIColor(hexString: "#FFFE85")!),
                           Pair(id: 149, key: "_", value: "••——•—", isVisible: true, color: UIColor(hexString: "#AEFFD4")!),
                           Pair(id: 150, key: ":", value: "———•••", isVisible: true, color: UIColor(hexString: "#99FFC8")!),
                           Pair(id: 151, key: ";", value: "—•—•—•", isVisible: true, color: UIColor(hexString: "#85E7FF")!),
                           Pair(id: 152, key: "?", value: "••——••", isVisible: true, color: UIColor(hexString: "#BDFFD0")!),
                           Pair(id: 153, key: "!", value: "—•—•——", isVisible: true, color: UIColor(hexString: "#FF8AF3")!),
                           Pair(id: 154, key: "-", value: "—••••—", isVisible: true, color: UIColor(hexString: "#8FFFC7")!),
                           Pair(id: 155, key: "+", value: "•—•—•", isVisible: true, color: UIColor(hexString: "#85B0FF")!),
                           Pair(id: 156, key: "/", value: "—••—•", isVisible: true, color: UIColor(hexString: "#FFD6C2")!),
                           Pair(id: 157, key: "(", value: "—•——•", isVisible: true, color: UIColor(hexString: "#B3FF8F")!),
                           Pair(id: 158, key: ")", value: "—•——•—", isVisible: true, color: UIColor(hexString: "#94FFAF")!),
                           Pair(id: 159, key: "=", value: "—•••—", isVisible: true, color: UIColor(hexString: "#EFFFC7")!),
                           Pair(id: 160, key: "@", value: "•——•—•", isVisible: true, color: UIColor(hexString: "#C7C8FF")!),
                           Pair(id: 170, key: " ", value: " ", isVisible: false, color: UIColor(hexString: "#FFFFFF")!)
        ]
        let polishAlphabet = Alphabet(id: 1, countryCode: "PL", name: "Polski", pairs: polishPairs, isSelected: false)
     
        let engilshPairs = [Pair(id: 101, key: "A", value: "•—", isVisible: true, color: UIColor(hexString: "#FAC7FF")!),
                            Pair(id: 102, key: "B", value: "—•••", isVisible: true, color: UIColor(hexString: "#FFCF94")!),
                            Pair(id: 103, key: "C", value: "—•—•", isVisible: true, color: UIColor(hexString: "#FFEBC2")!),
                            Pair(id: 105, key: "D", value: "—••", isVisible: true, color: UIColor(hexString: "#B3DBFF")!),
                            Pair(id: 106, key: "E", value: "•", isVisible: true, color: UIColor(hexString: "#CF99FF")!),
                            Pair(id: 108, key: "F", value: "••—•", isVisible: true, color: UIColor(hexString: "#FFA199")!),
                            Pair(id: 109, key: "G", value: "——•", isVisible: true, color: UIColor(hexString: "#FDFFCC")!),
                            Pair(id: 110, key: "H", value: "••••", isVisible: true, color: UIColor(hexString: "#85F2FF")!),
                            Pair(id: 111, key: "I", value: "••", isVisible: true, color: UIColor(hexString: "#B7FFA3")!),
                            Pair(id: 112, key: "J", value: "•———", isVisible: true, color: UIColor(hexString: "#9ECAFF")!),
                            Pair(id: 113, key: "K", value: "—•—", isVisible: true, color: UIColor(hexString: "#F3FF8A")!),
                            Pair(id: 114, key: "L", value: "•—••", isVisible: true, color: UIColor(hexString: "#B280FF")!),
                            Pair(id: 116, key: "M", value: "——", isVisible: true, color: UIColor(hexString: "#8FADFF")!),
                            Pair(id: 117, key: "N", value: "—•", isVisible: true, color: UIColor(hexString: "#C7E7FF")!),
                            Pair(id: 119, key: "O", value: "———", isVisible: true, color: UIColor(hexString: "#FFCEB3")!),
                            Pair(id: 121, key: "P", value: "•——•", isVisible: true, color: UIColor(hexString: "#E5C7FF")!),
                            Pair(id: 122, key: "Q", value: "——•—", isVisible: true, color: UIColor(hexString: "#FFDB99")!),
                            Pair(id: 123, key: "R", value: "•—•", isVisible: true, color: UIColor(hexString: "#A7FF8F")!),
                            Pair(id: 124, key: "S", value: "•••", isVisible: true, color: UIColor(hexString: "#FFD994")!),
                            Pair(id: 126, key: "T", value: "—", isVisible: true, color: UIColor(hexString: "#97FF8F")!),
                            Pair(id: 127, key: "U", value: "••—", isVisible: true, color: UIColor(hexString: "#B8F0FF")!),
                            Pair(id: 128, key: "V", value: "•••—", isVisible: true, color: UIColor(hexString: "#CE80FF")!),
                            Pair(id: 129, key: "W", value: "•——", isVisible: true, color: UIColor(hexString: "#FFA39E")!),
                            Pair(id: 130, key: "X", value: "—••—", isVisible: true, color: UIColor(hexString: "#A3C2FF")!),
                            Pair(id: 131, key: "Y", value: "—•——", isVisible: true, color: UIColor(hexString: "#FFAEFA")!),
                            Pair(id: 132, key: "Z", value: "——••", isVisible: true, color: UIColor(hexString: "#E480FF")!),
                            Pair(id: 135, key: "0", value: "—————", isVisible: true, color: UIColor(hexString: "#BDFFB8")!),
                            Pair(id: 136, key: "1", value: "•————", isVisible: true, color: UIColor(hexString: "#A3C0FF")!),
                            Pair(id: 137, key: "2", value: "••———", isVisible: true, color: UIColor(hexString: "#E1FF80")!),
                            Pair(id: 138, key: "3", value: "•••——", isVisible: true, color: UIColor(hexString: "#E4FFA3")!),
                            Pair(id: 139, key: "4", value: "••••—", isVisible: true, color: UIColor(hexString: "#FFE0B8")!),
                            Pair(id: 140, key: "5", value: "•••••", isVisible: true, color: UIColor(hexString: "#D1FFAE")!),
                            Pair(id: 141, key: "6", value: "—••••", isVisible: true, color: UIColor(hexString: "#FFC2FD")!),
                            Pair(id: 142, key: "7", value: "——•••", isVisible: true, color: UIColor(hexString: "#8097FF")!),
                            Pair(id: 143, key: "8", value: "———••", isVisible: true, color: UIColor(hexString: "#E3BDFF")!),
                            Pair(id: 144, key: "9", value: "————•", isVisible: true, color: UIColor(hexString: "#AEFFB4")!),
                            Pair(id: 145, key: ".", value: "•—•—•—", isVisible: true, color: UIColor(hexString: "#AEAFFF")!),
                            Pair(id: 146, key: ",", value: "——••——", isVisible: true, color: UIColor(hexString: "#FFFFC7")!),
                            Pair(id: 147, key: "'", value: "•————•", isVisible: true, color: UIColor(hexString: "#F6FFC2")!),
                            Pair(id: 148, key: "\"", value: "•—••—•", isVisible: true, color: UIColor(hexString: "#B7AEFF")!),
                            Pair(id: 149, key: "_", value: "••——•—", isVisible: true, color: UIColor(hexString: "#A8FF85")!),
                            Pair(id: 150, key: ":", value: "———•••", isVisible: true, color: UIColor(hexString: "#FFE880")!),
                            Pair(id: 151, key: ";", value: "—•—•—•", isVisible: true, color: UIColor(hexString: "#FFAEBD")!),
                            Pair(id: 152, key: "?", value: "••——••", isVisible: true, color: UIColor(hexString: "#FFCCE8")!),
                            Pair(id: 153, key: "!", value: "—•—•——", isVisible: true, color: UIColor(hexString: "#DEC2FF")!),
                            Pair(id: 154, key: "-", value: "—••••—", isVisible: true, color: UIColor(hexString: "#AEDDFF")!),
                            Pair(id: 155, key: "+", value: "•—•—•", isVisible: true, color: UIColor(hexString: "#FF80D9")!),
                            Pair(id: 156, key: "/", value: "—••—•", isVisible: true, color: UIColor(hexString: "#FFC3C2")!),
                            Pair(id: 157, key: "(", value: "—•——•", isVisible: true, color: UIColor(hexString: "#FFFE85")!),
                            Pair(id: 158, key: ")", value: "—•——•—", isVisible: true, color: UIColor(hexString: "#AEFFD4")!),
                            Pair(id: 159, key: "=", value: "—•••—", isVisible: true, color: UIColor(hexString: "#99FFC8")!),
                            Pair(id: 160, key: "@", value: "•——•—•", isVisible: true,  color: UIColor(hexString:"#85E7FF")!),
                            Pair(id: 170, key: " ", value: " ", isVisible: false, color: UIColor(hexString: "#FFFFFF")!)
        ]
        let englishAlphabet = Alphabet(id: 2, countryCode: "GB", name: "English", pairs: engilshPairs, isSelected: false)
        self.createOrUpdate(englishAlphabet, update: true).subscribe().dispose()
        self.createOrUpdate(polishAlphabet, update: true).subscribe().dispose()
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
