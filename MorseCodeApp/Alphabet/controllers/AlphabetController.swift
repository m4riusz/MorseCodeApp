//
//  AlphabetController.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 17/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import UIKit

class AlphabetController: BaseViewController {
    
    fileprivate var tableView: UITableView?
    fileprivate let viewModel: AlphabetViewModelProtocol = AlphabetViewModel(alphabetRepository: AlphabetRepository())
    
    override func initialize() {
        self.initTableView()
        self.initBindings()
    }
    
    fileprivate func initTableView() {
        self.tableView = UITableView()
        self.tableView?.register(AlphabetCell.self)
        self.view.addSubview(self.tableView!)
        
        self.tableView?.snp.makeConstraints({ [unowned self] make in
            make.edges.equalToSuperview()
        })
    }
    
    fileprivate func initBindings() {
        
    }
}
