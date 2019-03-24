//
//  EmptyView.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 24/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import UIKit

class EmptyView: UIView {
    
    fileprivate var titleLabel: Label?
    
    fileprivate struct Sizes {
        static let titleLabelFontSize: CGFloat = 20
    }
    
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
        self.titleLabel = Label(.semiBold(size: Sizes.titleLabelFontSize, color: .grayLight), textAligment: .center)
        self.titleLabel?.numberOfLines = 0
        self.addSubview(self.titleLabel!)
        
        self.titleLabel?.snp.makeConstraints({ [unowned self] make in
            make.top.greaterThanOrEqualToSuperview()
            make.left.greaterThanOrEqualToSuperview()
            make.right.greaterThanOrEqualToSuperview()
            make.bottom.greaterThanOrEqualToSuperview()
            make.center.equalToSuperview()
        })
    }
}
