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
    func select(_ alphabet: Alphabet) -> Completable
    func createOrUpdate(_ alphabet: Alphabet, update: Bool) -> Observable<Void>
    func getAll() -> Observable<[Alphabet]>
    func getAll(with predicate: NSPredicate) -> Observable<[Alphabet]>
    func delete(_ alphabet: Alphabet) -> Observable<Void>
    func reset()
}
