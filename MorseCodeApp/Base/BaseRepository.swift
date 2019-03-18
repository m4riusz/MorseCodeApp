//
//  BaseRepository.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 18/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

protocol BaseRepositoryProtocol {
    associatedtype T: BaseObject
    func createOrUpdate(object: T) -> Single<T>
    func getById(_ id: String) -> Single<T>
}
