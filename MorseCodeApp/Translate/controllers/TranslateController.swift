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
import Foundation

class TranslateController: BaseViewController<TranslateViewModel> {
    
    fileprivate var errorLabel: Label?
    fileprivate var inputTextView: UITextView?
    fileprivate var outputTextView: UITextView?
    fileprivate let bag = DisposeBag()
    
    fileprivate struct Sizes {
        static let infoLabelFontSize: CGFloat = 16
        static let letterSpacing: Double = 1.5
        static let inputTextFontSize: CGFloat = 16
        static let outputTextFontSie: CGFloat = 16
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TranslateTitle".localized()
    }
    
    override func initialize() {
        self.initErrorLabel()
        self.initInputTextView()
        self.initOutputTextView()
        self.initBindings()
    }
    
    fileprivate func initErrorLabel() {
        self.errorLabel = Label(.semiBold(size: Sizes.infoLabelFontSize, color: .white), textAligment: .center)
        self.errorLabel?.backgroundColor = .global(.red)
        self.view.addSubview(self.errorLabel!)
        
        self.errorLabel?.snp.makeConstraints({ make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        })
    }
    
    fileprivate func initInputTextView() {
        self.inputTextView = UITextView()
        self.inputTextView?.font = UIFont.systemFont(ofSize: Sizes.inputTextFontSize)
        self.view.addSubview(self.inputTextView!)
        
        self.inputTextView?.snp.makeConstraints({ [unowned self] make in
            make.top.equalTo(self.errorLabel!.snp.bottom).offset(Spacing.normal)
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
        let errorClickDriver = self.errorLabel!.rx
            .tapGesture()
            .flatMapLatest { _ in return Observable<Void>.just(Void()) }
            .asDriver(onErrorJustReturn: Void())
        
        
        let input = TranslateViewModel.Input(text: inputTextDriver,
                                             removeUnknownCharacters: errorClickDriver)
        
        let output = self.viewModel.transform(input: input)
        
        output.text
            .flatMapLatest({ pairs -> Driver<[NSAttributedString]> in
                return .just(pairs.map { NSAttributedString(text: $0.value,
                                                            textColor: $0.color,
                                                            fontSize: Sizes.outputTextFontSie)})
            })
            .flatMapLatest({ attributedTexts -> Driver<NSAttributedString> in
                let mutableAttributedString = NSMutableAttributedString()
                attributedTexts.forEach { mutableAttributedString.append($0)}
                mutableAttributedString.addAttribute(.kern,
                                                     value: Sizes.letterSpacing,
                                                     range: mutableAttributedString.all())
                return .just(mutableAttributedString)
            })
            .drive(self.outputTextView!.rx.attributedText)
            .disposed(by: self.bag)
        
        output.unknownCharactersDriver
            .drive(onNext: { [weak self] characters in
                guard !characters.isEmpty else {
                    self?.errorLabel?.text = ""
                    return
                }
                self?.errorLabel?.text = "Not supported characters: \(characters.joined(separator: ", "))"
            })
            .disposed(by: self.bag)
        
        output.fixedText
            .drive(onNext: { [weak self] fixedText in
                self?.inputTextView?.text = fixedText
            })
            .disposed(by: self.bag)
    }
}
