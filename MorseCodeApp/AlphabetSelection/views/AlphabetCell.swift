//
//  AlphabetCell.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 22/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import UIKit
import FlagKit

class AlphabetCell: BaseTableViewCell {
    
    override var isSelected: Bool { didSet { self.updateForSelectedChange() }}
    fileprivate var containerView: UIView?
    fileprivate var countryImageView: UIImageView?
    fileprivate var nameLabel: Label?
    var alphabet: Alphabet? { willSet { self.updateForData(data: newValue) }}
    
    fileprivate struct Sizes {
        static let cornerRadius: CGFloat = 10
        static let nameLabelFontSize: CGFloat = 18
    }
    
    override func initialize() {
        self.cornerRadius = Sizes.cornerRadius
        self.initContainerView()
        self.initCountryImageView()
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
    
    fileprivate func initCountryImageView() {
        self.countryImageView = UIImageView()
        self.countryImageView?.setContentHuggingPriority(.required, for: .horizontal)
        self.containerView?.addSubview(self.countryImageView!)
        
        self.countryImageView?.snp.makeConstraints({ [unowned self] make in
            make.top.equalToSuperview().offset(Spacing.normal)
            make.left.equalToSuperview().offset(Spacing.normal)
            make.bottom.equalToSuperview().offset(-Spacing.normal)
        })
    }
    
    fileprivate func initNameLabel() {
        self.nameLabel = Label(.bold(size: Sizes.nameLabelFontSize, color: .black))
        self.containerView?.addSubview(self.nameLabel!)
        
        self.nameLabel?.snp.makeConstraints({ [unowned self] make in
            make.top.equalToSuperview().offset(Spacing.normal)
            make.left.equalTo(self.countryImageView!.snp.right).offset(Spacing.normal)
            make.right.equalToSuperview().offset(-Spacing.normal)
            make.bottom.equalToSuperview().offset(-Spacing.normal)
        })
    }
    
    fileprivate func updateForSelectedChange() {
        let size = Sizes.nameLabelFontSize
        self.nameLabel?.style = self.isSelected ? .bold(size: size, color: .black) : .normal(size: size, color: .black)
    }
    
    fileprivate func updateForData(data: Alphabet?) {
        self.nameLabel?.text = data?.name
        self.isSelected = data?.isSelected ?? false
        guard let countryCode = data?.countryCode, let flag = Flag(countryCode: countryCode) else {
            return
        }
        self.countryImageView?.image = flag.image(style: .roundedRect)
    }
}
