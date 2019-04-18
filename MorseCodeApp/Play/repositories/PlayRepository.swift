//
//  PlayRepository.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 30/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import Foundation
import RxSwift

protocol PlayRepositoryProtocol {
    func selectPlayType(_ playType: PlayType) -> Observable<Void>
    func createOrUpdatePlayType(_ playType: PlayType, update: Bool) -> Observable<Void>
    func getPlayTypes() -> Observable<[PlayType]>
    func reset()
}
