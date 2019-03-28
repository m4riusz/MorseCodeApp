//
//  Globals.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 17/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import Foundation

struct AppDefaults {
    static let schemeVersion: UInt64 = 4
}

enum Colors: String {
    case turquoise = "color_turquoise"
    case turquoiseLight = "color_turquoise_light"
    case turquoiseDark = "color_turquoise_dark"
    case white = "color_white"
    case black = "color_black"
    case gray = "color_gray"
    case grayLight = "color_light_gray"
}

enum Images: String {
    case alphabet = "ic_alphabet"
    case settings = "ic_settings"
    case info = "ic_info"
    case translate = "ic_translate"
}
