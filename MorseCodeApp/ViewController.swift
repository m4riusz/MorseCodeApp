//
//  ViewController.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 15/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import UIKit
import RxSwift
import Crashlytics
import RxCocoa

class ViewController: UIViewController {
    fileprivate let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
        button.setTitle("Crash", for: [])
        button.rx.tap
            .subscribe(onNext: { _ in
                Crashlytics.sharedInstance().crash()
            })
            .disposed(by: self.bag)
        self.view.addSubview(button)
    }
}

