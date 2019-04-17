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
        let removeUnknownCharacters: Driver<Void>
    }
    
    struct Output {
        let text: Driver<[Pair]>
        let alphabet: Driver<Alphabet?>
        let unknownCharactersDriver: Driver<[String]>
        let fixedText: Driver<String>
    }
    
    fileprivate let alphabetRepository: AlphabetRepositoryProtocol
    
    init(alphabetRepository: AlphabetRepositoryProtocol) {
        self.alphabetRepository = alphabetRepository
    }
    
    func transform(input: TranslateViewModel.Input) -> TranslateViewModel.Output {
    
        let inputTextObservable = input.text
            .asObservable()
        
        let inputRemoveUnknownCharacters = input.removeUnknownCharacters
            .asObservable()
            .share()
        
        let selectedAlphabetObservable = self.alphabetRepository.getAll()
            .flatMapLatest { items -> Observable<Alphabet?> in
                return .just(items.first(where: { $0.isSelected }))
            }
        
        let pairsObservable = selectedAlphabetObservable
            .flatMapLatest { alphabet -> Observable<[Pair]> in
                return .just(alphabet?.pairs ?? [])
            }
        
        let outputTextObservable = Observable.combineLatest(inputTextObservable, pairsObservable) { text, pairs -> [Pair]in
            return text
                .uppercased()
                .map { String($0) }
                .compactMap({ character -> Pair? in
                    return pairs.first(where: { pair in pair.key == character })
                })
            }

        let unknownCharactersPositionsObservable = Observable.combineLatest(inputTextObservable, pairsObservable) { text, pairs -> [String] in
            return Array(Set(text
                    .map { String($0) }
                    .filter { character -> Bool in
                        return !pairs.contains(where: { pair in pair.key == character.uppercased() })
                    }))
        }
    
        let cleanTextObservable = Observable.combineLatest(inputTextObservable, unknownCharactersPositionsObservable) { text, unsuported -> String in
            let unsuportedUpperCased = unsuported.map { $0.uppercased() }
            return text.filter { !unsuportedUpperCased.contains(String($0).uppercased()) }
        }
        
        let fixedTextObservable = inputRemoveUnknownCharacters.withLatestFrom(cleanTextObservable) { _, outputText -> String in
            return outputText
        }
        
        let outputTextDriver = outputTextObservable.asDriver(onErrorJustReturn: [])
        let selectedAlphabetDriver = selectedAlphabetObservable.asDriver(onErrorJustReturn: nil)
        let unknownCharactersPositionsDriver = unknownCharactersPositionsObservable.asDriver(onErrorJustReturn: [])
        let fixedTextDriver = fixedTextObservable.asDriver(onErrorJustReturn: "")
        
        return Output(text: outputTextDriver,
                      alphabet: selectedAlphabetDriver,
                      unknownCharactersDriver: unknownCharactersPositionsDriver,
                      fixedText: fixedTextDriver)
    }
}
