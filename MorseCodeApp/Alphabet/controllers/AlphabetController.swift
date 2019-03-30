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
import FlagKit

class AlphabetController: BaseViewController<AlphabetViewModel> {
    
    fileprivate var pairTableView: UITableView?
    fileprivate var playView: PlayTypeView?
    fileprivate let bag = DisposeBag()
    
    fileprivate struct Sizes {
        static let alphabetContainerViewHeight: CGFloat = 60
    }
    
    override func initialize() {
        self.title = "AlphabetTitle".localized()
        self.initTableView()
        self.initNavigationBarButton()
        self.initPlayButton()
        self.initBindings()
    }
    
    fileprivate func initTableView() {
        self.pairTableView = UITableView()
        self.pairTableView?.backgroundColor = .clear
        self.pairTableView?.register(PairCell.self)
        self.pairTableView?.backgroundView = EmptyView(text: "AlphabetNoAlphabetSelected".localized())
        self.pairTableView?.tableFooterView = UIView()
        self.view.addSubview(self.pairTableView!)
        
        self.pairTableView?.snp.makeConstraints({ [unowned self] make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        })
    }
    
    fileprivate func initNavigationBarButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: nil, style: .plain, target: nil, action: nil)
    }
    
    fileprivate func initPlayButton() {
        self.playView = PlayTypeView()
        self.view.addSubview(self.playView!)
        
        self.playView?.snp.makeConstraints({ [unowned self] make in
            make.edges.equalToSuperview()
        })
    }
    
    fileprivate func initBindings() {
        self.navigationItem.rightBarButtonItem?.rx.tap
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                let controller = UINavigationController(rootViewController: DependencyContainer.resolve(AlphabetSelectionController.self))
                self?.navigationController?.present(controller, animated: true)
            })
            .disposed(by: self.bag)
        
        let viewWillAppearAction = self.rx.sentMessage(#selector(viewWillAppear(_:)))
            .flatMapLatest { _ -> Observable<Void> in return .just(Void() )}
            .asDriver(onErrorJustReturn: Void())
        
        let playTypeSelectionAction = self.playView!.playType
            .asObservable()
            .asDriver(onErrorJustReturn: nil)
            .unwrap()

        
        let output = self.viewModel.transform(input: AlphabetViewModel.Input(trigger: viewWillAppearAction,
                                                                             playTypeSelection: playTypeSelectionAction))
        
        output.pairs
            .do(onNext: { [weak self] pairs in
                self?.pairTableView?.backgroundView?.isHidden = pairs.count > 0
            })
            .drive(self.pairTableView!.rx.items(cellType: PairCell.self)) { _, item, cell in
                cell.pair = item
            }.disposed(by: self.bag)
        
        output.alphabet
            .drive(onNext: { [weak self] alphabet in
                guard let countryCode = alphabet?.countryCode, let flagImage = Flag(countryCode: countryCode) else {
                    self?.navigationItem.rightBarButtonItem?.image = nil
                    self?.navigationItem.rightBarButtonItem?.title = "Choose".localized()
                    return
                }
                self?.navigationItem.rightBarButtonItem?.image = flagImage.image(style: .roundedRect).withRenderingMode(.alwaysOriginal)
                self?.navigationItem.rightBarButtonItem?.title = nil
            })
            .disposed(by: self.bag)
        
        output.playTypes
            .drive(onNext: { [weak self] playTypes in
                self?.playView?.isHidden = playTypes.count == 0
                self?.playView?.setItems(playTypes)
            })
            .disposed(by: self.bag)
        
        output.playTypeChanged
            .drive()
            .disposed(by: self.bag)
    }
}
