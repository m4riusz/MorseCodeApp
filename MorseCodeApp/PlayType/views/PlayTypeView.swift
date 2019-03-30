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

class PlayTypeView: UIView {
    
    fileprivate var floatActionButton: JJFloatingActionButton?
    let playType: PublishSubject<PlayType?> = PublishSubject()
    
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
    }
    
    fileprivate func initFloatActionButton() {
        self.floatActionButton = JJFloatingActionButton()
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
    
    func setItems(_ playTypes: [PlayType]) {
        self.floatActionButton?.buttonImage = nil
        self.floatActionButton?.items = playTypes.map { self.initActionItem($0)}
    }
    
    fileprivate func initActionItem(_ playType: PlayType) -> JJActionItem {
        let button = JJActionItem()
        button.buttonImage = .global(playType.image)
        button.titleLabel.text = playType.name.localized()
        button.titleLabel.font = .boldSystemFont(ofSize: UIFont.systemFontSize)
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
