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

protocol AlphabetViewModelProtocol {
    func setAlphabetForCountryCode(_ countryCode: String)
    
    func getAlphabetDriver() -> Driver<Alphabet>
    func getErrorDriver() -> Driver<String>
}

struct AlphabetViewModel: AlphabetViewModelProtocol {
    
    fileprivate let alphabet: BehaviorRelay<Alphabet?> = BehaviorRelay<Alphabet?>(value: nil)
    fileprivate let error: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    fileprivate let alphabetRepository: AlphabetRepositoryProtocol
    fileprivate let bag = DisposeBag()
    
    init(alphabetRepository: AlphabetRepositoryProtocol) {
        self.alphabetRepository = alphabetRepository
    }
    
    func setAlphabetForCountryCode(_ countryCode: String) {
        self.error.accept("")
        self.alphabetRepository.getByCountyCode(countryCode)
            .subscribe(onSuccess: { alphabet in
                self.error.accept("")
                self.alphabet.accept(alphabet)
            }, onError: { error in
                self.error.accept(error.localizedDescription)
            })
            .disposed(by: self.bag)
    }
    
    func getAlphabetDriver() -> Driver<Alphabet> {
        return Observable<Alphabet>.empty().asDriver(onErrorJustReturn: Alphabet(countryCode: "", pairs: []))
    }
    
    func getErrorDriver() -> Driver<String> {
        return self.error.distinctUntilChanged().asDriver(onErrorJustReturn: "")
    }
}
