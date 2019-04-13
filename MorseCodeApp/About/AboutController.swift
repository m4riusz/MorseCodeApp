//
//  AboutController.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 17/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture

class AboutController: UITableViewController {
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "AboutTitle".localized()
        self.view.rx.longPressGesture().asControlEvent()
            .subscribe(onNext: { [weak self] _ in
                let repo = DependencyContainer.resolve(AlphabetRepositoryProtocol.self)
                repo.reset()
            })
            .disposed(by: self.bag)
    }
}
