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
        let playText: Driver<String>
        let playTypeSelection: Driver<PlayType>
        let loadTriger: Driver<Void>
        let playTriger: Driver<Void>
    }
    
    struct Output {
        let playTypes: Driver<[PlaySectionData]>
        let playTypeChanged: Driver<Void>
    }
    
    fileprivate let playTypeRepository: PlayRepositoryProtocol
    
    init(playTypeRepository: PlayRepositoryProtocol) {
        self.playTypeRepository = playTypeRepository
    }
    
    func transform(input: PlayViewModel.Input) -> PlayViewModel.Output {
        let playTypeChangedAction = input.playTypeSelection.asObservable()
            .flatMapLatest { self.playTypeRepository.selectPlayType($0) }
        
        let textToPlayAction = input.playText
        
        let playTypesAction = input.loadTriger.asObservable()
            .flatMapLatest { _ -> Observable<[PlayType]> in
                return self.playTypeRepository.getPlayTypes()
            }
            .withLatestFrom(textToPlayAction, resultSelector: { playTypes, text -> [PlaySectionData] in
                    let headerDataType = PlaySectionDataType.header(text)
                    let itemsDataType = playTypes.map { PlaySectionDataType.item($0) }
                    let footerDataType = PlaySectionDataType.footer
                    return [PlaySectionData(items: [headerDataType] + itemsDataType + [footerDataType])]
            })

        let playTypesDriver = playTypesAction.asDriver(onErrorJustReturn: [])
        let playTypeChangedDriver = playTypeChangedAction.asDriver(onErrorJustReturn: Void())
        
        return Output(playTypes: playTypesDriver,
                      playTypeChanged: playTypeChangedDriver)
    }
}
