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
    
    override func initialize() {
        self.initContainerView()
        self.initPlayTypeImageView()
        self.initPlayTypeNameLabel()
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
        self.playTypeNameLabel = Label(.normal(size: 16, color: .gray))
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
