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
        let selection: Driver<Alphabet>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let alphabets: Driver<[Alphabet]>
        let pairs: Driver<[Pair]>
        let error: Driver<Error>
    }
    
    fileprivate let alphabetRepository: AlphabetRepositoryProtocol
    
    init(alphabetRepository: AlphabetRepositoryProtocol) {
        self.alphabetRepository = alphabetRepository
    }
    
    func transform(input: AlphabetViewModel.Input) -> AlphabetViewModel.Output {
        let loading = PublishSubject<Bool>()
        let error = PublishSubject<Error>()
        
        let alphabets = input.trigger.asObservable()
            .flatMapLatest {
                return self.alphabetRepository.queryAll()
                    .do(onNext: { _ in
                        loading.onNext(true)
                    }, onError: { err in
                        loading.onNext(false)
                        error.onNext(err)
                    }, onCompleted: {
                        loading.onNext(false)
                    })
            }
        let selectedAlphabet = alphabets.flatMapLatest { items -> Observable<Alphabet?> in
            return .just(items.first(where: { $0.isSelected }))
        }
            .unwrap()
        let pairs = Observable.merge(selectedAlphabet, input.selection.asObservable())
            .do(onNext: { alphabet in
                self.alphabetRepository.selectAlphabet(entity: alphabet).subscribe()
            })
            .flatMapLatest { alphabet -> Observable<[Pair]> in
                 return .just(alphabet.pairs)
        }
        
        let loadingDriver = loading.distinctUntilChanged().asDriver(onErrorJustReturn: false)
        let alphabetsDriver = alphabets.asDriver(onErrorJustReturn: [])
        let pairsDriver = pairs.asDriver(onErrorJustReturn: [])
        let errorDriver = error.asObservable().asDriver(onErrorRecover: { return Driver.just($0) })
  
        return Output(loading: loadingDriver,
                      alphabets: alphabetsDriver,
                      pairs: pairsDriver,
                      error: errorDriver)
    }
}
