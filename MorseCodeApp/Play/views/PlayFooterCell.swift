//
//  PlayFooterCell.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 07/04/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import UIKit

class PlayFooterCell: BaseTableViewCell {
    
    fileprivate var containerView: UIView?
    fileprivate var playButton: UIButton?
    
    struct Sizes {
        static let playButtonCornerRadius: CGFloat = 10
        static let playButtonInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    override func initialize() {
        self.initContainerView()
        self.initializePlayButton()
    }
    
    fileprivate func initContainerView() {
        self.containerView = UIView()
        self.contentView.addSubview(self.containerView!)
        
        self.containerView?.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(Spacing.small)
            make.left.equalToSuperview().offset(Spacing.normal)
            make.right.equalToSuperview().offset(-Spacing.normal)
            make.bottom.equalToSuperview().offset(-Spacing.small)
        })
    }
    
    fileprivate func initializePlayButton() {
        self.playButton = UIButton()
        self.playButton?.setImage(.global(.play), for: .normal)
        self.playButton?.setImage(.global(.pause), for: .disabled)
        self.playButton?.backgroundColor = .global(.turquoise)
        self.playButton?.tintColor = .global(.white)
        self.playButton?.cornerRadius = Sizes.playButtonCornerRadius
        self.playButton?.contentEdgeInsets = Sizes.playButtonInsets
        self.containerView?.addSubview(self.playButton!)
        
        self.playButton?.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
    }
}
