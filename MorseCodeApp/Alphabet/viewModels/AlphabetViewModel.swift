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
        let playReady: Driver<Void>
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
            .flatMapLatest { return self.playTypeRepository.setTextToPlay($0) }
            .flatMapLatest { _ in return Observable<Void>.just(Void())}
        
        let pairs = selectedAlphabetAction.flatMapLatest { return Observable<[Pair]>.just($0?.pairs ?? []) }
        
        let alphabetDriver = selectedAlphabetAction.asDriver(onErrorJustReturn: nil)
        let playReadyDriver = playTriggerAction.asDriver(onErrorJustReturn: Void())
        let pairsDriver = pairs.asDriver(onErrorJustReturn: [])
        let errorDriver = error.asObservable().asDriver(onErrorRecover: { return Driver.just($0) })
  
        return Output(alphabet: alphabetDriver,
                      playReady: playReadyDriver,
                      pairs: pairsDriver,
                      error: errorDriver)
    }
}
