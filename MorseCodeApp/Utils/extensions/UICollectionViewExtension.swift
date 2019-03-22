//
//  UICollectionViewExtension.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 22/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UICollectionView {
    func register(_ cell: UICollectionViewCell.Type) {
        self.register(cell, forCellWithReuseIdentifier: cell.reusableIdentifier())
    }
}

extension Reactive where Base: UICollectionView {
    
    public func items<S: Sequence, Cell: UICollectionViewCell, O : ObservableType>
        (cellType: Cell.Type = Cell.self)
        -> (_ source: O)
        -> (_ configureCell: @escaping (Int, S.Iterator.Element, Cell) -> Void)
        -> Disposable
        where O.E == S {
            return self.items(cellIdentifier: cellType.reusableIdentifier(), cellType: cellType)
    }
}
