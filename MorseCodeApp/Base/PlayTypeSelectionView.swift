//
//  PlayTypeSelectionView.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 29/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import JJFloatingActionButton
import UIKit

enum PlayType {
    case screen
    case flash
    case sound
    case vibration
}

typealias PlayTypeSelectionGateway = (_ type: PlayType) -> Void

class PlayTypeSelectionView: UIView {
    
    fileprivate var floatActionButton: JJFloatingActionButton?
    var gateway: PlayTypeSelectionGateway?
    
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
        
        let screenFloatAction = self.initActionItem(image: .phone,
                                                    title: "Screen".localized(),
                                                    type: .screen)
        let vibrationFloatAction = self.initActionItem(image: .vibration,
                                                    title: "Vibration".localized(),
                                                    type: .screen)
        let soundFloatAction = self.initActionItem(image: .sound,
                                                    title: "Sound".localized(),
                                                    type: .screen)
        let flashFloatAction = self.initActionItem(image: .flash,
                                                   title: "Flash".localized(),
                                                   type: .screen)
        
        self.floatActionButton?.addItem(screenFloatAction)
        self.floatActionButton?.addItem(vibrationFloatAction)
        self.floatActionButton?.addItem(soundFloatAction)
        self.floatActionButton?.addItem(flashFloatAction)
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
    
    fileprivate func initActionItem(image: Images, title: String, type: PlayType) -> JJActionItem {
        let button = JJActionItem()
        button.buttonImage = .global(image)
        button.titleLabel.text = title
        button.titleLabel.font = .boldSystemFont(ofSize: UIFont.systemFontSize)
        button.action = { [weak self] item in
            self?.floatActionButton?.buttonImage = item.buttonImage
            self?.gateway?(type)
        }
        return button
    }
}
