//
//  PlayTypeView.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 29/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import JJFloatingActionButton
import UIKit
import RxSwift
import RxGesture

class PlayTypeView: UIView {
    
    fileprivate var floatActionButton: JJFloatingActionButton?
    fileprivate let bag = DisposeBag()
    let playType: PublishSubject<PlayType?> = PublishSubject()
    let play: PublishSubject<Void> = PublishSubject()
    
    init() {
        super.init(frame: .zero)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(frame: .zero)
        self.initialize()
    }
    
    fileprivate func initialize() {
        self.initFloatActionButton()
        self.initBindings()
    }
    
    fileprivate func initFloatActionButton() {
        self.floatActionButton = JJFloatingActionButton()
        self.floatActionButton?.isUserInteractionEnabled = false
        self.floatActionButton?.buttonImageColor = .global(.white)
        self.floatActionButton?.buttonColor = .global(.turquoise)
        self.floatActionButton?.highlightedButtonColor = .global(.turquoiseDark)
        self.floatActionButton?.itemSizeRatio = CGFloat(0.8)
        self.addSubview(self.floatActionButton!)
        
        self.floatActionButton?.snp.makeConstraints { [unowned self] make in
            make.right.equalTo(self.safeAreaLayoutGuide.snp.right).offset(-Spacing.normal)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-Spacing.normal)
        }
    }
    
    fileprivate func initBindings() {
        self.floatActionButton?.rx.tapGesture()
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let itemCount = self?.floatActionButton?.items.count, itemCount > 0 else {
                    return
                }
                guard self?.floatActionButton?.buttonState != .open else {
                    self?.floatActionButton?.close()
                    return
                }
                guard self?.floatActionButton?.items.contains(where: { $0.isSelected }) ?? false else {
                    self?.floatActionButton?.open()
                    return
                }
                print("------------------ CLICK ------------------")
            })
            .disposed(by: self.bag)
    }
    
    func setItems(_ playTypes: [PlayType]) {
        self.floatActionButton?.buttonImage = nil
        self.floatActionButton?.items = playTypes.map { self.initActionItem($0)}
    }
    
    fileprivate func initActionItem(_ playType: PlayType) -> JJActionItem {
        let button = JJActionItem()
        button.buttonImage = .global(playType.image)
        button.titleLabel.text = playType.name.localized()
        button.titleLabel.font = .boldSystemFont(ofSize: UIFont.systemFontSize)
        button.isSelected = playType.isSelected
        button.action = { [weak self] item in
            self?.playType.onNext(playType)
        }
        guard playType.isSelected else {
            return button
        }
        self.floatActionButton?.buttonImage = .global(playType.image)
        return button
    }
}
