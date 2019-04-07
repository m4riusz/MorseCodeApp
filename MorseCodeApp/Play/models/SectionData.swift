//
//  SectionData.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 07/04/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import Foundation
import RxDataSources

enum PlaySectionDataType {
    case header(_ title: String)
    case item(_ item: PlayType)
    case footer
}

struct PlaySectionData {
    var items: [PlaySectionDataType]
}

extension PlaySectionData: SectionModelType {
    
    init(original: PlaySectionData, items: [PlaySectionDataType]) {
        self = original
        self.items = items
    }
}
