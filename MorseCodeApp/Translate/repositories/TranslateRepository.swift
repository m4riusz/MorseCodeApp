//
//  TranslateRepository.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 18/04/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

protocol TranslateRepositoryProtocol {
    func select(_ alphabet: TranslateMode) -> Observable<Void>
    func getAll() -> Observable<[TranslateMode]>
    func reset()
}
