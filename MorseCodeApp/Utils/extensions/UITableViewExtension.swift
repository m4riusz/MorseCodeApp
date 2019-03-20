//
//  UITableViewExtension.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 20/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import UIKit

extension UITableView {
    func register(_ cell: UITableViewCell.Type) {
        self.register(cell, forCellReuseIdentifier: cell.reusableIdentifier())
    }
}
