//
//  AlphabetSelectionViewModel.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 27/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct AlphabetSelectionViewModel: ViewModelType {
    
    struct Input {
        let trigger: Driver<Void>
        let selection: Driver<Alphabet>
    }
    
    struct Output {
        let alphabets: Driver<[Alphabet]>
        let error: Driver<Error>
    }
    
    fileprivate let alphabetRepository: AlphabetRepositoryProtocol
    fileprivate let bag = DisposeBag()
    
    init(alphabetRepository: AlphabetRepositoryProtocol) {
        self.alphabetRepository = alphabetRepository
    }
    
    func transform(input: AlphabetSelectionViewModel.Input) -> AlphabetSelectionViewModel.Output {
        let error = PublishSubject<Error>()
        
       input.selection.asObservable()
        .flatMapLatest { return self.alphabetRepository.select($0) }
        .subscribe()
        .disposed(by: self.bag)
        
        let alphabets = input.trigger.asObservable()
            .flatMapLatest { return self.alphabetRepository.getAll() }
        
        let alphabetsDriver = alphabets.asDriver(onErrorJustReturn: [])
        let errorDriver = error.asObservable().asDriver(onErrorRecover: { return Driver.just($0) })
        
        return Output(alphabets: alphabetsDriver,
                      error: errorDriver)
    }
}
