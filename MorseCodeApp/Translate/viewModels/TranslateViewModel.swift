//
//  TranslateViewModel.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 26/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct TranslateViewModel: ViewModelType {
    
    struct Input {
        let text: Driver<String>
    }
    
    struct Output {
        let text: Driver<String>
        let errorText: Driver<String>
        let alphabets: Driver<[Alphabet]>
    }
    
    fileprivate let alphabetRepository: AlphabetRepositoryProtocol
    
    init(alphabetRepository: AlphabetRepositoryProtocol) {
        self.alphabetRepository = alphabetRepository
    }
    
    func transform(input: TranslateViewModel.Input) -> TranslateViewModel.Output {
    
        let alphabets = self.alphabetRepository.getAll()
        
        let selectedAlphabet = alphabets.flatMapLatest { items -> Observable<Alphabet?> in
            return .just(items.first(where: { $0.isSelected }))
            }
            .unwrap()
        let pairs = selectedAlphabet
            .flatMapLatest { alphabet -> Observable<[Pair]> in
                return .just(alphabet.pairs)
        }
        
        let outputText = input.text.asObservable().withLatestFrom(pairs) { text, pairs -> String in
            let mapped = text
                .uppercased()
                .map { character in pairs.first(where: { pair in pair.key == String(character) })?.value ?? ""}
            return mapped.joined()
        }
        
        let outputTextDriver = outputText.asDriver(onErrorJustReturn: "")
        let errorTextDriver = Observable<String>.just("Some error").asDriver(onErrorJustReturn: "")
        let alphabetsDriver = alphabets.asDriver(onErrorJustReturn: [])
        
        
        return Output(text: outputTextDriver,
                      errorText: errorTextDriver,
                      alphabets: alphabetsDriver)
    }
}
