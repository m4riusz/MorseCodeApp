//
//  AlphabetSelectionController.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 27/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AlphabetSelectionController: BaseViewController<AlphabetSelectionViewModel> {
    
    fileprivate var tableView: UITableView?
    fileprivate let bag = DisposeBag()
    
    override func initialize() {
        self.title = "AlphabetChoose".localized()
        self.initTableView()
        self.initNavigationBarButton()
        self.initBindings()
    }
    
    fileprivate func initTableView() {
        self.tableView = UITableView()
        self.tableView?.register(AlphabetCell.self)
        self.tableView?.backgroundView = EmptyView(text: "AlphabetNoAlphabetsEmptyView".localized())
        self.tableView?.tableFooterView = UIView()
        self.view.addSubview(self.tableView!)
        
        self.tableView?.snp.makeConstraints({ [unowned self] make in
            make.edges.equalToSuperview()
        })
    }
    
    fileprivate func initNavigationBarButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
    }
    
    fileprivate func initBindings() {
        
        self.navigationItem.rightBarButtonItem?.rx.tap
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: self.bag)
        
        let viewWillAppearAction = self.rx.methodInvoked(#selector(viewWillAppear(_:)))
            .flatMapLatest { _ in return Observable<Void>.just(Void()) }
            .asDriver(onErrorJustReturn: Void())
        
        let selectionAction = self.tableView!.rx.modelSelected(Alphabet.self).asDriver()
        
        let output = self.viewModel.transform(input: AlphabetSelectionViewModel.Input(trigger: viewWillAppearAction,
                                                                                      selection: selectionAction))
        
        output.alphabets
            .asObservable()
            .do(onNext: { [weak self] alphabets in
                self?.tableView?.backgroundView?.isHidden = alphabets.count > 0
            })
            .bind(to: self.tableView!.rx.items(cellType: AlphabetCell.self)) { _, item, cell in
                cell.alphabet = item
                cell.accessoryType = item.isSelected ? .checkmark : .none
            }.disposed(by: self.bag)
    }
}
