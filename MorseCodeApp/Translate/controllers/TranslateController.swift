//
//  TranslateController.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 17/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TranslateController: BaseViewController<TranslateViewModel> {
    
    fileprivate var inputTextView: UITextView?
    fileprivate var outputTextView: UITextView?
    fileprivate let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TranslateTitle".localized()
    }
    
    override func initialize() {
        self.initInputTextView()
        self.initOutputTextView()
        self.initBindings()
    }
    
    fileprivate func initInputTextView() {
        self.inputTextView = UITextView()
        self.view.addSubview(self.inputTextView!)
        
        self.inputTextView?.snp.makeConstraints({ [unowned self] make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(Spacing.normal)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(Spacing.normal)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-Spacing.normal)
        })
    }
    
    fileprivate func initOutputTextView() {
        self.outputTextView = UITextView()
        self.view.addSubview(self.outputTextView!)
        
        self.outputTextView?.snp.makeConstraints({ [unowned self] make in
            make.top.equalTo(self.inputTextView!.snp.bottom).offset(Spacing.normal)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(Spacing.normal)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-Spacing.normal)
            make.height.equalTo(self.inputTextView!.snp.height)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-Spacing.normal)
        })
    }
    
    fileprivate func initBindings() {
        let inputTextDriver = self.inputTextView!.rx.text.orEmpty.changed.asDriver()
        
        let input = TranslateViewModel.Input(text: inputTextDriver)
        
        let output = self.viewModel.transform(input: input)
        
        output.text
            .drive(self.outputTextView!.rx.text)
            .disposed(by: self.bag)
    }
}
