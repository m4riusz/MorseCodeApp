//
//  Label.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 24/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import UIKit


class Label: UILabel {
    
    enum Style {
        case italic(size: CGFloat, color: Colors)
        case light(size: CGFloat, color: Colors)
        case normal(size: CGFloat, color: Colors)
        case semiBold(size: CGFloat, color: Colors)
        case bold(size: CGFloat, color: Colors)
    }
    
    var style: Label.Style = .normal(size: 14, color: .black) { didSet { self.update() }}
    
    convenience init(_ style: Label.Style) {
        self.init(style, textAligment: .left)
    }
    
    convenience init(_ style: Label.Style, textAligment: NSTextAlignment) {
        self.init()
        self.style = style
        self.textAlignment = textAligment
        self.update()
    }
    
    fileprivate func update() {
        switch style {
        case .italic(let size, let color):
            self.font = UIFont.italicSystemFont(ofSize: size)
            self.textColor = .global(color)
        case .light(let size, let color):
            self.font = UIFont.systemFont(ofSize: size, weight: .light)
            self.textColor = .global(color)
        case .normal(let size, let color):
            self.font = UIFont.systemFont(ofSize: size, weight: .regular)
            self.textColor = .global(color)
        case .semiBold(let size, let color):
            self.font = UIFont.systemFont(ofSize: size, weight: .semibold)
            self.textColor = .global(color)
        case .bold(let size, let color):
            self.font = UIFont.boldSystemFont(ofSize: size)
            self.textColor = .global(color)
        }
    }
}

