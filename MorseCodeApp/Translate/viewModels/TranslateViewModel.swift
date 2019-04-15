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
    
        let alphabetsAction = self.alphabetRepository.getAll()
        
        let selectedAlphabetAction = alphabetsAction.flatMapLatest { items -> Observable<Alphabet?> in
                return .just(items.first(where: { $0.isSelected }))
            }
            .unwrap()
        
        let pairsAction = selectedAlphabetAction
            .flatMapLatest { alphabet -> Observable<[Pair]> in
                return .just(alphabet.pairs)
        }
        
        let mappedText = Observable.combineLatest(input.text.asObservable(), pairsAction) { text, pairs -> [PairSearchResult] in
            return text.uppercased()
                .map({ character -> PairSearchResult in
                    guard let pair = pairs.first(where: { pair in pair.key == String(character) }) else {
                        return .notFount(String(character))
                    }
                    return .found(pair)
                })
            }
            .share()
        
        
        let outputTextAction = mappedText
            .flatMapLatest { pairSearchResults -> Observable<[Pair]> in
                let pairs = pairSearchResults.compactMap({ pairSearchResult -> Pair? in
                    switch pairSearchResult {
                    case .found(let pair):
                        return pair
                    case .notFount:
                        return nil
                    }
                })
                return .just(pairs)
            }
        
        let unknownCharactersPositionsAction = mappedText
            .flatMapLatest { pairSearchResults -> Observable<[String]> in
                let unknownCharacters = pairSearchResults.compactMap({ pairSearchResult -> String? in
                    switch pairSearchResult {
                    case .found:
                        return nil
                    case .notFount(let key):
                        return key
                    }
                })
                return .just(Array(Set(unknownCharacters)))
        }
        
        let fixedTextAction = input.removeUnknownCharacters.asObservable().withLatestFrom(outputTextAction) { _, outputText -> String in
            return outputText.map { $0.key }.joined()
        }
        
        let outputTextDriver = outputTextAction.asDriver(onErrorJustReturn: [])
        let alphabetsDriver = alphabetsAction.asDriver(onErrorJustReturn: [])
        let unknownCharactersDriver = unknownCharactersPositionsAction.asDriver(onErrorJustReturn: [])
        let fixedTextDriver = fixedTextAction.asDriver(onErrorJustReturn: "")
        
        return Output(text: outputTextDriver,
                      alphabets: alphabetsDriver,
                      unknownCharactersDriver: unknownCharactersDriver,
                      fixedText: fixedTextDriver)
    }
}
