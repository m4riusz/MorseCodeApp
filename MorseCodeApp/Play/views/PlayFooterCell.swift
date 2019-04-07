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
        
        self.containerView?.snp.makeConstraints({ [unowned self] make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(Spacing.normal)
            make.left.equalTo(self.safeAreaLayoutGuide.snp.left).offset(Spacing.normal)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.right).offset(-Spacing.normal)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-Spacing.normal)
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
        
        self.playButton?.snp.makeConstraints({ [unowned self] make in
            make.edges.equalToSuperview()
        })
    }
}
