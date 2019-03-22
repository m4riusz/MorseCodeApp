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
    
    fileprivate struct Sizes {
        static let cornerRadius: CGFloat = 10
    }
    
    override func initialize() {
        self.cornerRadius = Sizes.cornerRadius
        self.initContainerView()
        self.initNameLabel()
        self.updateForSelectedChange()
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
        self.nameLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        self.containerView?.addSubview(self.nameLabel!)
        
        self.nameLabel?.snp.makeConstraints({ [unowned self] make in
            make.top.equalToSuperview().offset(Spacing.normal)
            make.left.equalToSuperview().offset(Spacing.normal)
            make.right.equalToSuperview().offset(-Spacing.normal)
            make.bottom.equalToSuperview().offset(-Spacing.normal)
        })
    }
    
    fileprivate func updateForSelectedChange() {
        self.nameLabel?.textColor = .global(self.isSelected ? .white : .white)
        self.containerView?.backgroundColor = .global(self.isSelected ? .turquoiseDark : .turquoiseLight)
    }
    
    fileprivate func updateForData(data: Alphabet?) {
        self.nameLabel?.text = data?.countryCode
    }
}
