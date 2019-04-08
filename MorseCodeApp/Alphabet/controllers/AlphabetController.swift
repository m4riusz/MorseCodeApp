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
import RxGesture

class AlphabetController: BaseViewController<AlphabetViewModel> {
    
    fileprivate var pairTableView: UITableView?
    fileprivate var playButton: UIButton?
    fileprivate let bag = DisposeBag()
    
    fileprivate struct Sizes {
        static let alphabetContainerViewHeight: CGFloat = 60
        static let playButtonSize: CGSize = CGSize(width: 60, height: 60)
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
            make.edges.equalToSuperview()
        })
    }
    
    fileprivate func initNavigationBarButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: nil, style: .plain, target: nil, action: nil)
    }
    
    fileprivate func initPlayButton() {
        self.playButton = UIButton()
        self.playButton?.setImage(.global(.play), for: .normal)
        self.playButton?.tintColor = .global(.white)
        self.playButton?.backgroundColor = .global(.turquoise)
        self.playButton?.cornerRadius = Sizes.playButtonSize.width / 2
        self.view?.addSubview(self.playButton!)
        
        self.playButton?.snp.makeConstraints { [unowned self] make in
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-Spacing.normal)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-Spacing.normal)
            make.size.equalTo(Sizes.playButtonSize)
        }
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
        
        let playAction =  self.playButton!.rx.controlEvent(.touchUpInside)
            .withLatestFrom(self.pairTableView!.rx.modelSelected(Pair.self))
            .flatMapLatest { pair in return Observable<String>.just(pair.key)}
            .asDriver(onErrorJustReturn: "")
        
        let output = self.viewModel.transform(input: AlphabetViewModel.Input(trigger: viewWillAppearAction,
                                                                             playTrigger: playAction))
        
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
        
        output.playReady
            .drive(onNext: { [weak self] _ in
                let controller = DependencyContainer.resolve(PlayController.self)
                self?.navigationController?.pushViewController(controller)
            })
            .disposed(by: self.bag)
    }
}
