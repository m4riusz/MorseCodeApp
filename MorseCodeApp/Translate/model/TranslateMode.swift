//
//  TranslateMode.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 18/04/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import Foundation

struct TranslateMode {
    
    enum Mode: Int {
        case textToMorse
        case morseToText
    }
    
    let id: Int
    let mode: Mode
    let isSelected: Bool
}
