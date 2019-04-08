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

        let dataSource = RxTableViewSectionedReloadDataSource<PlaySectionData>(
            configureCell: { dataSource, tableView, indexPath, item in
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
        
        let tableSelectionAction = self.tableView!.rx
            .modelSelected(PlaySectionDataType.self)
            .asControlEvent()
            .share()
        
        let playTypeSelectedAction = tableSelectionAction
            .flatMapLatest { item -> Observable<PlayType?> in
                switch item {
                case .item(let playType):
                    return .just(playType)
                default:
                    return .just(nil)
                }
            }
            .asDriver(onErrorJustReturn: nil)
            .unwrap()
        
        let playAction = tableSelectionAction
            .flatMapLatest { item -> Observable<Void?> in
                switch item {
                case .footer:
                    return .just(Void())
                default:
                    return .just(nil)
                }
            }
            .asDriver(onErrorJustReturn: nil)
            .unwrap()
        
        let output = self.viewModel.transform(input: PlayViewModel.Input(playTypeSelection: playTypeSelectedAction,
                                                                         loadTriger: viewWillAppearAction,
                                                                         playTriger: playAction))
    
        output.playTypes.asObservable()
            .bind(to: self.tableView!.rx.items(dataSource: dataSource))
            .disposed(by: self.bag)
        
        output.playTypeChanged
            .drive()
            .disposed(by: self.bag)
    }
}
