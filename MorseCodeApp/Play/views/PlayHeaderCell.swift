//
//  PlayHeaderCell.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 07/04/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import UIKit

class PlayHeaderCell: BaseTableViewCell {
    
    fileprivate var containerView: UIView?
    fileprivate var playTextLabel: Label?
    
    var playText: String? { willSet { self.updateForData(data: newValue) } }
    
    override func initialize() {
        self.initContainerView()
        self.initPlayTextLabel()
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
    
    fileprivate func initPlayTextLabel() {
        self.playTextLabel = Label(.italic(size: 16, color: .gray), textAligment: .center)
        self.playTextLabel?.numberOfLines = 0
        self.containerView?.addSubview(self.playTextLabel!)
        
        self.playTextLabel?.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
    }
    
    fileprivate func updateForData(data: String?) {
        self.playTextLabel?.text = data
    }
}
