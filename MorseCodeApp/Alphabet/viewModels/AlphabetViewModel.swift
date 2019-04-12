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
        let playTrigger: Driver<String>
    }
    
    struct Output {
        let alphabet: Driver<Alphabet?>
        let playReady: Driver<String>
        let pairs: Driver<[Pair]>
        let error: Driver<Error>
    }
    
    fileprivate let alphabetRepository: AlphabetRepositoryProtocol
    fileprivate let playTypeRepository: PlayRepositoryProtocol
    
    init(alphabetRepository: AlphabetRepositoryProtocol,
         playTypeRepository: PlayRepositoryProtocol) {
        self.alphabetRepository = alphabetRepository
        self.playTypeRepository = playTypeRepository
    }
    
    func transform(input: AlphabetViewModel.Input) -> AlphabetViewModel.Output {
        let error = PublishSubject<Error>()
        
        let selectedAlphabetAction = input.trigger.asObservable()
                .flatMapLatest { return self.alphabetRepository.getAll() }
                .flatMapLatest { return Observable<Alphabet?>.just($0.first(where: { $0.isSelected })) }
                .share()
        
        let playTriggerAction = input.playTrigger.asObservable()
        
        let pairs = selectedAlphabetAction.flatMapLatest { optionalPairs -> Observable<[Pair]> in
            let pairs = optionalPairs?.pairs.filter { $0.isVisible } ?? []
            return .just(pairs)
        }
        let alphabetDriver = selectedAlphabetAction.asDriver(onErrorJustReturn: nil)
        let playReadyDriver = playTriggerAction.asDriver(onErrorJustReturn: "")
        let pairsDriver = pairs.asDriver(onErrorJustReturn: [])
        let errorDriver = error.asObservable().asDriver(onErrorRecover: { return Driver.just($0) })
  
        return Output(alphabet: alphabetDriver,
                      playReady: playReadyDriver,
                      pairs: pairsDriver,
                      error: errorDriver)
    }
}
