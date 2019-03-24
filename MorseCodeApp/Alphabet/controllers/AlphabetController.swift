//
//  AlphabetController.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 17/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import UIKit
import RxDataSources
import RealmSwift
import RxSwift
import RxCocoa
import RxSwiftExt

class AlphabetController: BaseViewController<AlphabetViewModel> {
    
    fileprivate var alphabetCollectionView: UICollectionView?
    fileprivate var pairTableView: UITableView?
    fileprivate let bag = DisposeBag()
    
    fileprivate struct Sizes {
        static let alphabetContainerViewHeight: CGFloat = 60
    }
    
    override func initialize() {
        self.title = "AlphabetTitle".localized()
        self.initAlphabetCollectionView()
        self.initTableView()
        self.initBindings()
    }
    
    fileprivate func initAlphabetCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        self.alphabetCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        self.alphabetCollectionView?.backgroundColor = .clear
        self.alphabetCollectionView?.register(AlphabetCell.self)
        self.alphabetCollectionView?.borderColor = .global(.grayLight)
        self.alphabetCollectionView?.borderWidth = 1
        self.alphabetCollectionView?.backgroundView = EmptyView(text: "AlphabetNoAlphabetsEmptyView".localized())
        self.view.addSubview(self.alphabetCollectionView!)
        
        self.alphabetCollectionView?.snp.makeConstraints({ [unowned self] make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
            make.height.equalTo(Sizes.alphabetContainerViewHeight)
        })
    }
    
    fileprivate func initTableView() {
        self.pairTableView = UITableView()
        self.pairTableView?.backgroundColor = .clear
        self.pairTableView?.register(PairCell.self)
        self.pairTableView?.backgroundView = EmptyView(text: "AlphabetNoAlphabetSelected".localized())
        self.pairTableView?.tableFooterView = UIView()
        self.view.addSubview(self.pairTableView!)
        
        self.pairTableView?.snp.makeConstraints({ [unowned self] make in
            make.top.equalTo(self.alphabetCollectionView!.snp.bottom)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        })
    }
    
    fileprivate func initBindings() {
        let viewWillAppearAction = self.rx.sentMessage(#selector(viewWillAppear(_:)))
            .flatMapLatest { _ -> Observable<Void> in return .just(Void() )}
            .asDriver(onErrorJustReturn: Void())
        
        let itemSelectionAction = self.alphabetCollectionView!.rx.modelSelected(Alphabet.self).asDriver()
        
        let output = self.viewModel.transform(input: AlphabetViewModel.Input(trigger: viewWillAppearAction,
                                                                            selection: itemSelectionAction))
        
        output.alphabets
            .do(onNext: { [weak self] alphabets in
                self?.alphabetCollectionView?.backgroundView?.isHidden = alphabets.count > 0
            })
            .drive(self.alphabetCollectionView!.rx.items(cellType: AlphabetCell.self)) { _, item, cell in
                cell.alphabet = item
            }.disposed(by: self.bag)
        
        output.pairs
            .do(onNext: { [weak self] pairs in
                self?.pairTableView?.backgroundView?.isHidden = pairs.count > 0
            })
            .drive(self.pairTableView!.rx.items(cellType: PairCell.self)) { _, item, cell in
                cell.pair = item
            }.disposed(by: self.bag)
    }
}
