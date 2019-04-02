//
//  JJFloatingActionButtonExtension.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 31/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import Foundation
import RxSwift
import JJFloatingActionButton

extension JJFloatingActionButton {
    
    fileprivate struct AssociatedKeys {
        static var selectedPlayType = "playType"
    }
    
    var selectedPlayType: PublishSubject<PlayType?> {
        get {
            guard let playType = objc_getAssociatedObject(self, &AssociatedKeys.selectedPlayType) as? PublishSubject<PlayType?> else {
                return PublishSubject()
            }
            return playType
        }
        
        set(value) {
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.selectedPlayType,
                                     value,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
        self.selectedPlayType = PublishSubject()
    }
    
    func setItems(_ playTypes: [PlayType]) {
        self.buttonImage = nil
        self.items = playTypes.map { self.initActionItem($0) }
    }
    
    func getSelectedObservable() -> Observable<PlayType?> {
        return self.selectedPlayType.asObservable()
    }
    
    fileprivate func initActionItem(_ playType: PlayType) -> JJActionItem {
        let button = JJActionItem()
        button.buttonImage = .global(playType.image)
        button.titleLabel.text = playType.name.localized()
        button.titleLabel.textColor = .global(.black)
        button.titleLabel.font = .boldSystemFont(ofSize: UIFont.systemFontSize)
        button.isSelected = playType.isSelected
        button.action = { [weak self] _ in
            self?.selectedPlayType.onNext(playType)
        }
        guard playType.isSelected else {
            return button
        }
        self.buttonImage = .global(playType.image)
        return button
    }
}
