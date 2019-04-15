//
//  PairResult.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 15/04/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import Foundation

enum PairSearchResult {
    case notFount(_ character: String)
    case found(_ pair: Pair)
}
