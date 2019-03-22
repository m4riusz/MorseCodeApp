//
//  AlphabetCell.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 22/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import UIKit

class AlphabetCell: BaseCollectionViewCell {
    
    override var isSelected: Bool { didSet { self.updateForSelectedChange() }}
    fileprivate var containerView: UIView?
    fileprivate var nameLabel: UILabel?
    var alphabet: Alphabet? {
        willSet {
            self.updateForData(data: newValue)
        }
    }
    
    override func initialize() {
        self.initContainerView()
        self.initNameLabel()
    }
    
    fileprivate func initContainerView() {
        self.containerView = UIView()
        self.addSubview(self.containerView!)
        
        self.containerView?.snp.makeConstraints({ [unowned self] make in
            make.edges.equalToSuperview()
        })
    }
    
    fileprivate func initNameLabel() {
        self.nameLabel = UILabel()
        self.nameLabel?.textColor = .black
        self.containerView?.addSubview(self.nameLabel!)
        
        self.nameLabel?.snp.makeConstraints({ [unowned self] make in
            make.top.equalToSuperview().offset(Spacing.normal)
            make.left.equalToSuperview().offset(Spacing.normal)
            make.right.equalToSuperview().offset(-Spacing.normal)
            make.bottom.equalToSuperview().offset(-Spacing.normal)
        })
    }
    
    fileprivate func updateForSelectedChange() {
        sel
    }
    
    fileprivate func updateForData(data: Alphabet?) {
        self.nameLabel?.text = data?.countryCode
    }
}
