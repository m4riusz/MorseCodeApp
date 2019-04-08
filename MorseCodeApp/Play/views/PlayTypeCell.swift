//
//  PlayTypeCell.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 07/04/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import UIKit

class PlayTypeCell: BaseTableViewCell {

    fileprivate var containerView: UIView?
    fileprivate var playTypeImageView: UIImageView?
    fileprivate var playTypeNameLabel: Label?
    var playType: PlayType? { willSet { self.updateForData(data: newValue) } }
    
    fileprivate struct Sizes {
        static let playTypeNameLabelFontSize: CGFloat = 16
    }
    
    override func initialize() {
        self.initContainerView()
        self.initPlayTypeImageView()
        self.initPlayTypeNameLabel()
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
    
    fileprivate func initPlayTypeImageView() {
        self.playTypeImageView = UIImageView()
        self.playTypeImageView?.tintColor = .global(.black)
        self.playTypeImageView?.contentMode = .scaleAspectFit
        self.playTypeImageView?.setContentHuggingPriority(.required, for: .horizontal)
        self.containerView?.addSubview(self.playTypeImageView!)
        
        self.playTypeImageView?.snp.makeConstraints({ make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        })
    }
    
    fileprivate func initPlayTypeNameLabel() {
        self.playTypeNameLabel = Label(.normal(size: Sizes.playTypeNameLabelFontSize, color: .gray))
        self.containerView?.addSubview(self.playTypeNameLabel!)
        
        self.playTypeNameLabel?.snp.makeConstraints({ [unowned self] make in
            make.top.equalToSuperview()
            make.left.equalTo(self.playTypeImageView!.snp.right).offset(Spacing.normal)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        })
    }
    
    fileprivate func updateForData(data: PlayType?) {
        guard let playType = data else {
            self.playTypeImageView?.image = nil
            self.playTypeNameLabel?.text = nil
            self.accessoryType = .none
            return
        }
        self.playTypeImageView?.image = .global(playType.image)
        self.playTypeNameLabel?.text = playType.name
        self.accessoryType = playType.isSelected ? .checkmark : .none
    }
}
