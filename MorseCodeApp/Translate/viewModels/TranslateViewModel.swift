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
        let alphabets: Driver<[Alphabet]>
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
            .debug("TEXT")
            .share()
        
        let inputRemoveUnknownCharacters = input.removeUnknownCharacters
            .asObservable()
            .share()
        
        let alphabetsObservable = self.alphabetRepository.getAll()
            .asObservable()
            .share()
        
        let selectedAlphabetObservable = alphabetsObservable.flatMapLatest { items -> Observable<Alphabet?> in
                return .just(items.first(where: { $0.isSelected }))
            }
            .unwrap()
        
        let pairsObservable = selectedAlphabetObservable
            .flatMapLatest { alphabet -> Observable<[Pair]> in
                return .just(alphabet.pairs)
            }
            .share()
        
        let outputTextObservable = Observable.combineLatest(inputTextObservable, pairsObservable) { text, pairs -> [Pair] in
            return text
                .uppercased()
                .map { String($0) }
                .compactMap({ character -> Pair? in
                    return pairs.first(where: { pair in pair.key == character })
                })
            }
            .share()

        let unknownCharactersPositionsObservable = inputTextObservable.withLatestFrom(pairsObservable) { text, pairs -> [String] in
            return text
                .map { String($0) }
                .filter { character -> Bool in
                    return !pairs.contains(where: { pair in pair.key == character.uppercased() })
                }
        }
            .debug("UNKNOW")
        .share()
        
        let cleanTextObservable = Observable.combineLatest(inputTextObservable, unknownCharactersPositionsObservable,
                                                           resultSelector: { text, unsuported -> String in
            let unsuportedUpperCased = unsuported.map { $0.uppercased() }
            return text.filter { unsuportedUpperCased.contains(String($0).uppercased()) }
        })
        
        let fixedTextObservable = inputRemoveUnknownCharacters.withLatestFrom(cleanTextObservable) { _, outputText -> String in
            return outputText
        }
        
        let outputTextDriver = outputTextObservable.asDriver(onErrorJustReturn: [])
        let alphabetsDriver = alphabetsObservable.asDriver(onErrorJustReturn: [])
        let unknownCharactersDriver = unknownCharactersPositionsObservable.asDriver(onErrorJustReturn: [])
        let fixedTextDriver = fixedTextObservable.asDriver(onErrorJustReturn: "")
        
        return Output(text: outputTextDriver,
                      alphabets: alphabetsDriver,
                      unknownCharactersDriver: unknownCharactersDriver,
                      fixedText: fixedTextDriver)
    }
}
