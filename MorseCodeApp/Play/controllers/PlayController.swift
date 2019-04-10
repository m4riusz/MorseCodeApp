//
//  PlayController.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 03/04/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class PlayController: BaseViewController<PlayViewModel> {
    
    fileprivate var tableView: UITableView?
    fileprivate let bag = DisposeBag()
    var textToPlay: String = ""
    
    override func initialize() {
        self.initTableView()
        self.initBindings()
    }
    
    fileprivate func initTableView() {
        self.tableView = UITableView()
        self.tableView?.register(PlayHeaderCell.self)
        self.tableView?.register(PlayTypeCell.self)
        self.tableView?.register(PlayFooterCell.self)
        self.tableView?.rowHeight = UITableView.automaticDimension
        self.tableView?.tableFooterView = UIView()
        self.view.addSubview(self.tableView!)
        
        self.tableView?.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
    }
    
    fileprivate func initBindings() {
        let viewWillAppearAction = self.view.rx.methodInvoked(#selector(viewWillAppear(_:)))
            .flatMapLatest { _ in return Observable<Void>.just(Void()) }
            .asDriver(onErrorJustReturn: Void())

        let tableSelectionAction = self.tableView!.rx
            .modelSelected(PlaySectionDataType.self)
            .asControlEvent()
            .share()
        
        let playTypeSelectedAction = self.initPlayTypeSelectedAction(tableSelectionAction)
            .asDriver(onErrorRecover: { error in fatalError("Error: \(error.localizedDescription)")})
        
        let playAction = self.initPlayAction(tableSelectionAction)
            .asDriver(onErrorRecover: { error in fatalError("Error: \(error.localizedDescription)")})
        
        let playTextAction = Observable<String>.just(self.textToPlay)
            .asDriver(onErrorJustReturn: "")
        
        let output = self.viewModel.transform(input: PlayViewModel.Input(playText: playTextAction,
                                                                         playTypeSelection: playTypeSelectedAction,
                                                                         loadTriger: viewWillAppearAction,
                                                                         playTriger: playAction))
    
        output.playTypes.asObservable()
            .bind(to: self.tableView!.rx.items(dataSource: self.initTableViewDataSource()))
            .disposed(by: self.bag)
        
        output.playTypeChanged
            .drive()
            .disposed(by: self.bag)
    }
    
    fileprivate func initTableViewDataSource() -> RxTableViewSectionedReloadDataSource<PlaySectionData> {
        return RxTableViewSectionedReloadDataSource<PlaySectionData>(
            configureCell: { _, tableView, _, item in
                switch item {
                case .header(let title):
                    let cell = tableView.dequeueReusableCell(withClass: PlayHeaderCell.self)
                    cell.selectionStyle = .none
                    cell.playText = title
                    return cell
                case .item(let itemData):
                    let cell = tableView.dequeueReusableCell(withClass: PlayTypeCell.self)
                    cell.playType = itemData
                    return cell
                case .footer:
                    let cell = tableView.dequeueReusableCell(withClass: PlayFooterCell.self)
                    cell.selectionStyle = .none
                    return cell
                }
        })
    }
    
    fileprivate func initPlayTypeSelectedAction(_ tableSelectionAction: Observable<PlaySectionDataType>) -> Observable<PlayType> {
        return tableSelectionAction
            .flatMapLatest { item -> Observable<PlayType?> in
                switch item {
                case .item(let playType):
                    return .just(playType)
                default:
                    return .just(nil)
                }
            }
            .unwrap()
    }
    
    fileprivate func initPlayAction(_ tableSelectionAction: Observable<PlaySectionDataType>) -> Observable<Void> {
        return tableSelectionAction
            .flatMapLatest { item -> Observable<Void?> in
                switch item {
                case .footer:
                    return .just(Void())
                default:
                    return .just(nil)
                }
            }
            .unwrap()
    }
}
