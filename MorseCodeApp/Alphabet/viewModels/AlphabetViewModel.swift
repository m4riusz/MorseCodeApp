//
//  AlphabetViewModel.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 19/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt

struct AlphabetViewModel: ViewModelType {
    
    struct Input {
        let trigger: Driver<Void>
        let playTypeSelection: Driver<PlayType>
    }
    
    struct Output {
        let alphabet: Driver<Alphabet?>
        let playTypes: Driver<[PlayType]>
        let playTypeChanged: Driver<Void>
        let pairs: Driver<[Pair]>
        let error: Driver<Error>
    }
    
    fileprivate let alphabetRepository: AlphabetRepositoryProtocol
    fileprivate let playTypeRepository: PlayTypeRepositoryProtocol
    
    init(alphabetRepository: AlphabetRepositoryProtocol,
         playTypeRepository: PlayTypeRepositoryProtocol) {
        self.alphabetRepository = alphabetRepository
        self.playTypeRepository = playTypeRepository
    }
    
    func transform(input: AlphabetViewModel.Input) -> AlphabetViewModel.Output {
        let error = PublishSubject<Error>()
        
        let selectedAlphabet =  input.trigger.asObservable()
                .flatMapLatest { return self.alphabetRepository.getAll() }
                .flatMapLatest { items -> Observable<Alphabet?> in
                    return .just(items.first(where: { $0.isSelected }))
        }
        let playTypes = input.trigger.asObservable()
            .flatMapLatest { return self.playTypeRepository.getAll() }
        let playTypeChanged = input.playTypeSelection.asObservable()
            .flatMapLatest { return self.playTypeRepository.select($0) }
            .flatMapLatest { _ in return Observable<Void>.just(Void()) }
        
        let pairs = selectedAlphabet
            .flatMapLatest { alphabet -> Observable<[Pair]> in return .just(alphabet?.pairs ?? []) }
        
        let alphabetDriver = selectedAlphabet.asDriver(onErrorJustReturn: nil)
        let playTypesDriver = playTypes.asDriver(onErrorJustReturn: [])
        let pairsDriver = pairs.asDriver(onErrorJustReturn: [])
        let errorDriver = error.asObservable().asDriver(onErrorRecover: { return Driver.just($0) })
        let playTypeChangedDriver = playTypeChanged.asDriver(onErrorJustReturn: Void())
  
        return Output(alphabet: alphabetDriver,
                      playTypes: playTypesDriver,
                      playTypeChanged: playTypeChangedDriver,
                      pairs: pairsDriver,
                      error: errorDriver)
    }
}
