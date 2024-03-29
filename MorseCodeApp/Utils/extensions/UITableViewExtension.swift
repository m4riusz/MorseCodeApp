//
//  UITableViewExtension.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 20/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UITableView {
    func register(_ cell: UITableViewCell.Type) {
        self.register(cell, forCellReuseIdentifier: cell.reusableIdentifier())
    }
}

extension Reactive where Base: UITableView {
    
    public func items<S: Sequence, Cell: UITableViewCell, O : ObservableType>
        (cellType: Cell.Type = Cell.self)
        -> (_ source: O)
        -> (_ configureCell: @escaping (Int, S.Iterator.Element, Cell) -> Void)
        -> Disposable
        where O.E == S {
            return self.items(cellIdentifier: cellType.reusableIdentifier(), cellType: cellType)
    }
}
