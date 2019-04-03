//
//  PlayViewModel.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 03/04/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import RxSwift
import RxCocoa

struct PlayViewModel: ViewModelType {
    
    struct Input {
        let playTypeSelection: Driver<PlayType>
        let loadTriger: Driver<Void>
        let playTriger: Driver<Void>
    }
    
    struct Output {
        let playTypes: Driver<[PlayType]>
        let playTypeChanged: Driver<Void>
        let playText: Driver<String>
    }
    
    fileprivate let playTypeRepository: PlayRepositoryProtocol
    
    init(playTypeRepository: PlayRepositoryProtocol) {
        self.playTypeRepository = playTypeRepository
    }
    
    func transform(input: PlayViewModel.Input) -> PlayViewModel.Output {
        let playTypeChangedAction = input.playTypeSelection.asObservable()
            .flatMapLatest { playType -> Completable in return self.playTypeRepository.selectPlayType(playType) }
            .flatMapLatest { _ -> Observable<Void> in return .just(Void()) }
        
        let playTypesAction = input.loadTriger.asObservable()
            .flatMapLatest { _ -> Observable<[PlayType]> in
                return self.playTypeRepository.getPlayTypes()
            }
        
        let playTypesDriver = playTypesAction.asDriver(onErrorJustReturn: [])
        let playTypeChangedDriver = playTypeChangedAction.asDriver(onErrorJustReturn: Void())
        let playTextDriver = Observable<String>.just("Test").asDriver(onErrorJustReturn: "")
        
        return Output(playTypes: playTypesDriver,
                      playTypeChanged: playTypeChangedDriver,
                      playText: playTextDriver)
    }
}
