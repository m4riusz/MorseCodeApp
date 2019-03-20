//
//  AlphabetUseCase.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 20/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import Foundation
import RxSwift

protocol AlphabetUseCaseProtocol {
    func alphabet(currencyCode: String) -> Observable<[Alphabet]>
}

struct AlphabetUseCase: AlphabetUseCaseProtocol {
    fileprivate let alphabetRepository: AlphabetRepositoryProtocol
    
    init(alphabetRepository: AlphabetRepositoryProtocol) {
        self.alphabetRepository = alphabetRepository
    }
    
    func alphabet(currencyCode: String) -> Observable<[Alphabet]> {
        return .empty()
    }
}


