//
//  AlphabetCell.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 20/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import UIKit
import SnapKit

class AlphabetCell: BaseTableViewCell {
    
    fileprivate var containerView: UIView?
    fileprivate var signLabelBackground: UIView?
    fileprivate var signLabel: UILabel?
    fileprivate var codeLabel: UILabel?
    var pair: Pair? {
        willSet {
            self.updateForData(data: newValue)
        }
    }
    
    override func initialize() {
        self.addShadow()
        self.initContainerView()
        self.initSingLabelBackground()
        self.initSignLabel()
        self.initCodeLabel()
    }
    
    fileprivate func initContainerView() {
        self.containerView = UIView()
        self.addSubview(self.containerView!)
        
        self.containerView?.snp.makeConstraints({ [unowned self] make in
            make.top.equalToSuperview().offset(Spacing.normal)
            make.left.equalToSuperview().offset(Spacing.normal)
            make.right.equalToSuperview().offset(-Spacing.normal)
            make.bottom.equalToSuperview().offset(-Spacing.normal)
        })
    }
    
    fileprivate func initSingLabelBackground() {
        self.signLabelBackground = UIView()
        self.signLabelBackground?.backgroundColor = .global(.turquoise)
        self.containerView?.addSubview(self.signLabelBackground!)
        
        self.signLabelBackground?.snp.makeConstraints({ [unowned self] make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(self.signLabelBackground!.snp.height)
        })
    }
    
    fileprivate func initSignLabel() {
        self.signLabel = UILabel()
        self.signLabelBackground?.addSubview(self.signLabel!)
        
        self.signLabel?.snp.makeConstraints({ [unowned self] make in
            make.edges.equalToSuperview()
        })
    }
    
    fileprivate func initCodeLabel() {
        self.codeLabel = UILabel()
        self.containerView?.addSubview(self.codeLabel!)
        
        self.codeLabel?.snp.makeConstraints({ [unowned self] make in
            make.top.equalToSuperview()
            make.left.equalTo(self.signLabelBackground!.snp.right).offset(Spacing.normal)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        })
    }
    
    fileprivate func updateForData(data: Pair?) {
        self.signLabel?.text = data?.key
        self.codeLabel?.text = data?.value
    }
}

