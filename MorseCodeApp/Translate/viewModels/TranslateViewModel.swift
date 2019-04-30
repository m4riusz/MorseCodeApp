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
        let toggleMode: Driver<Void>
    }
    
    struct Output {
        let text: Driver<(pairsResults: [Pair], translateMode: TranslateMode)>
        let alphabet: Driver<Alphabet?>
        let unknownCharactersDriver: Driver<[String]>
        let fixedText: Driver<String>
        let translateModes: Driver<[TranslateMode]>
        let empty: Driver<Void>
    }
    
    fileprivate let translateRepository: TranslateRepositoryProtocol
    fileprivate let alphabetRepository: AlphabetRepositoryProtocol
    
    init(translateRepository: TranslateRepositoryProtocol,
         alphabetRepository: AlphabetRepositoryProtocol) {
        self.translateRepository = translateRepository
        self.alphabetRepository = alphabetRepository
    }
    
    func transform(input: TranslateViewModel.Input) -> TranslateViewModel.Output {
    
        let inputTextObservable = input.text
            .asObservable()
        
        let inputRemoveUnknownCharactersObservable = input.removeUnknownCharacters
            .asObservable()
        
        let selectedAlphabetObservable = self.alphabetRepository.getAll()
            .flatMapLatest { items -> Observable<Alphabet?> in
                return .just(items.first(where: { $0.isSelected }))
            }
        
        let pairsObservable = selectedAlphabetObservable
            .flatMapLatest { alphabet -> Observable<[Pair]> in
                return .just(alphabet?.pairs ?? [])
            }
        
        let translateModes = self.translateRepository.getAll()
        let selectedTranslateMode = translateModes.flatMapLatest { modes -> Observable<TranslateMode> in
            return .just(modes.filter({ $0.isSelected }).first!)
        }
        
        let toggleModeObservable = input.toggleMode.asObservable()
            .withLatestFrom(translateModes) {  _, translateModes -> TranslateMode? in
                return translateModes.filter({ !$0.isSelected }).first
            }
            .unwrap()
            .flatMapLatest { return self.translateRepository.select($0) }
  
        let outputTextObservable = Observable.combineLatest(inputTextObservable, pairsObservable, selectedTranslateMode) { text, pairs, translateMode -> (pairsResults: [Pair], translateMode: TranslateMode) in
                switch translateMode.mode {
                case .textToMorse:
                    let mapResult = text
                        .uppercased()
                        .map { String($0) }
                        .compactMap({ character -> Pair? in
                            return pairs.first(where: { pair in pair.key == character })
                        })
                    return (pairsResults: Array(mapResult.map { [$0] }.joined(separator: [Pair.divider()])),
                            translateMode: translateMode)
                case .morseToText:
                    let pairsResult = text
                        .split(separator: Pair.dividerSymbol)
                        .map { String($0) }
                        .compactMap({ character -> Pair? in
                            return pairs.first(where: { pair in pair.value == character })
                        })
                        return (pairsResults: pairsResult,
                                translateMode: translateMode)
            }
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
        
        let fixedTextObservable = inputRemoveUnknownCharactersObservable.withLatestFrom(cleanTextObservable) { _, outputText -> String in
            return outputText
        }
        
        let outputTextDriver = outputTextObservable.asDriver(onErrorRecover: { fatalError($0.localizedDescription) })
        let selectedAlphabetDriver = selectedAlphabetObservable.asDriver(onErrorJustReturn: nil)
        let unknownCharactersPositionsDriver = unknownCharactersPositionsObservable.asDriver(onErrorJustReturn: [])
        let fixedTextDriver = fixedTextObservable.asDriver(onErrorJustReturn: "")
        let translateModesDriver = translateModes.asDriver(onErrorJustReturn: [])
        let emptyDriver = toggleModeObservable.asDriver(onErrorRecover: { fatalError($0.localizedDescription) })
        
        return Output(text: outputTextDriver,
                      alphabet: selectedAlphabetDriver,
                      unknownCharactersDriver: unknownCharactersPositionsDriver,
                      fixedText: fixedTextDriver,
                      translateModes: translateModesDriver,
                      empty: emptyDriver)
    }
}
