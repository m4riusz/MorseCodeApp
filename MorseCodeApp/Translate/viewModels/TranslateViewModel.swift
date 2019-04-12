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
        let text: Driver<[Pair]>
        let errorText: Driver<String>
        let alphabets: Driver<[Alphabet]>
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
        
         let outputTextAction = Observable.combineLatest(input.text.asObservable(), pairsAction) { text, pairs -> [Pair] in
            return text.uppercased()
                .map { character -> Pair in
                    guard let foundPair = pairs.first(where: { pair in pair.key == String(character) }) else {
                        return Pair(id: -1,
                                    key: String(character),
                                    value: "",
                                    isVisible: true,
                                    color: UIColor(hexString: "#FF0000")!)
                    }
                    return foundPair
            }
        }
        
        let unknownCharactersAction = outputTextAction
            .flatMapLatest { pairs -> Observable<Int> in
                return .just(pairs.filter({ $0.value.isEmpty }).count)
            }
            .flatMapLatest { invalidCharacters -> Observable<String> in
                guard invalidCharacters == 0 else {
                    return .just("Found \(invalidCharacters) problems");
                }
                return .just("")
            }
        
        
        let outputTextDriver = outputTextAction.asDriver(onErrorJustReturn: [])
        let errorTextDriver = unknownCharactersAction.asDriver(onErrorJustReturn: "")
        let alphabetsDriver = alphabetsAction.asDriver(onErrorJustReturn: [])
        
        
        return Output(text: outputTextDriver,
                      errorText: errorTextDriver,
                      alphabets: alphabetsDriver)
    }
}
