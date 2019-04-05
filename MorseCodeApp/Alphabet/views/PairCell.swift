//
//  PairCell.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 20/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import UIKit
import SnapKit

class PairCell: BaseTableViewCell {
    
    fileprivate var containerView: UIView?
    fileprivate var signLabelBackground: UIView?
    fileprivate var signLabel: Label?
    fileprivate var codeLabel: Label?
    var pair: Pair? { willSet { self.updateForData(data: newValue) } }
    
    fileprivate struct Sizes {
        static let signLabelFontSize: CGFloat = 24
        static let signLabelBackgroundSize: CGFloat = 50
        static let codeLabelFontSize: CGFloat = 40
    }
    
    override func initialize() {
        self.initContainerView()
        self.initSignLabelBackground()
        self.initSignLabel()
        self.initCodeLabel()
    }
    
    fileprivate func initContainerView() {
        self.containerView = UIView()
        self.addSubview(self.containerView!)
        
        self.containerView?.snp.makeConstraints({ [unowned self] make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(Spacing.normal)
            make.left.equalTo(self.safeAreaLayoutGuide.snp.left).offset(Spacing.normal)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.right).offset(-Spacing.normal)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-Spacing.normal)
        })
    }
    
    fileprivate func initSignLabelBackground() {
        self.signLabelBackground = UIView()
        self.signLabelBackground?.backgroundColor = .global(.turquoise)
        self.signLabelBackground?.cornerRadius = Sizes.signLabelBackgroundSize / 2
        self.containerView?.addSubview(self.signLabelBackground!)
        
        self.signLabelBackground?.snp.makeConstraints({ [unowned self] make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(self.signLabelBackground!.snp.height)
            make.height.equalTo(self.signLabelBackground!.snp.width)
            make.width.equalTo(Sizes.signLabelBackgroundSize)
        })
    }
    
    fileprivate func initSignLabel() {
        self.signLabel = Label(.bold(size: Sizes.signLabelFontSize, color: .white), textAligment: .center)
        self.signLabelBackground?.addSubview(self.signLabel!)
        
        self.signLabel?.snp.makeConstraints({ [unowned self] make in
            make.edges.equalToSuperview()
        })
    }
    
    fileprivate func initCodeLabel() {
        self.codeLabel = Label(.bold(size: Sizes.codeLabelFontSize, color: .black))
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

