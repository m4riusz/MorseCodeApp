//
//  EmptyView.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 24/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import UIKit

class EmptyView: UIView {
    
    fileprivate var titleLabel: UILabel?
    
    init(text: String) {
        super.init(frame: .zero)
        self.initialize()
        self.titleLabel?.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(frame: .zero)
        self.initialize()
        self.titleLabel?.text = ""
    }
    
    fileprivate func initialize() {
        self.titleLabel = UILabel()
        self.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        self.titleLabel?.textColor = .global(.grayLight)
        self.titleLabel?.numberOfLines = 2
        self.titleLabel?.textAlignment = .center
        self.addSubview(self.titleLabel!)
        
        self.titleLabel?.snp.makeConstraints({ [unowned self] make in
            make.center.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview().offset(Spacing.big)
            make.right.greaterThanOrEqualToSuperview().offset(-Spacing.big)
        })
    }
}
