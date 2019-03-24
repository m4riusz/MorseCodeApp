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
        var fontWeight: UIFont.Weight = .light
        var fontSize: CGFloat = 0.0
        var fontColor: UIColor = .black
        
        switch style {
        case .light(let size, let color):
            fontWeight = .light
            fontColor = .global(color)
            fontSize = size
        case .normal(let size, let color):
            fontWeight = .regular
            fontColor = .global(color)
            fontSize = size
        case .semiBold(let size, let color):
            fontWeight = .semibold
            fontColor = .global(color)
            fontSize = size
        case .bold(let size, let color):
            fontWeight = .bold
            fontColor = .global(color)
            fontSize = size
        }
        self.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        self.textColor = fontColor
    }
}

