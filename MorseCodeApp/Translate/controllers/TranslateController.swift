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
import FlagKit

class TranslateController: BaseViewController<TranslateViewModel> {
    
    fileprivate var errorLabel: Label?
    fileprivate var containerView: UIView?
    fileprivate var inputTextView: UITextView?
    fileprivate var outputTextView: UITextView?
    fileprivate var morseKeyboardView: MorseKeyboardView?
    fileprivate let bag = DisposeBag()
    
    fileprivate struct Sizes {
        static let infoLabelFontSize: CGFloat = 16
        static let letterSpacing: Double = 1.5
        static let inputTextFontSize: CGFloat = 16
        static let outputTextFontSie: CGFloat = 16
        static let morseCodeKeyboardHeight: CGFloat = 50
    }
    
    override func initialize() {
        self.title = "TranslateTitle".localized()
        self.initContainerView()
        self.initErrorLabel()
        self.initInputTextView()
        self.initOutputTextView()
        self.initMorseKeyboardView()
        self.initNavigationBarButton()
        self.initBindings()
    }
    
    fileprivate func initContainerView() {
        self.containerView = UIView()
        self.view.addSubview(self.containerView!)
        
        self.initContainerViewConstraints()
    }
    
    fileprivate func initContainerViewConstraints(bottomOffset: CGFloat = 0) {
        self.containerView?.snp.remakeConstraints({ make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(bottomOffset)
        })
    }
    
    fileprivate func initErrorLabel() {
        self.errorLabel = Label(.semiBold(size: Sizes.infoLabelFontSize, color: .white), textAligment: .center)
        self.errorLabel?.backgroundColor = .global(.red)
        self.containerView?.addSubview(self.errorLabel!)
        
        self.errorLabel?.snp.makeConstraints({ make in
            make.top.equalTo(self.containerView!.safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        })
    }
    
    fileprivate func initInputTextView() {
        self.inputTextView = UITextView()
        self.inputTextView?.borderColor = .global(.grayLight)
        self.inputTextView?.borderWidth = 0.5
        self.inputTextView?.font = UIFont.systemFont(ofSize: Sizes.inputTextFontSize)
        self.containerView?.addSubview(self.inputTextView!)
        
        self.inputTextView?.snp.makeConstraints({ [unowned self] make in
            make.top.equalTo(self.errorLabel!.snp.bottom).offset(Spacing.normal)
            make.left.equalTo(self.containerView!.safeAreaLayoutGuide.snp.left).offset(Spacing.normal)
            make.right.equalTo(self.containerView!.safeAreaLayoutGuide.snp.right).offset(-Spacing.normal)
        })
    }
    
    fileprivate func initOutputTextView() {
        self.outputTextView = UITextView()
        self.outputTextView?.isEditable = false
        self.outputTextView?.borderColor = .global(.grayLight)
        self.outputTextView?.borderWidth = 0.5
        self.containerView?.addSubview(self.outputTextView!)
        
        self.outputTextView?.snp.makeConstraints({ [unowned self] make in
            make.top.equalTo(self.inputTextView!.snp.bottom).offset(Spacing.normal)
            make.left.equalTo(self.containerView!.safeAreaLayoutGuide.snp.left).offset(Spacing.normal)
            make.right.equalTo(self.containerView!.safeAreaLayoutGuide.snp.right).offset(-Spacing.normal)
            make.height.equalTo(self.inputTextView!.snp.height)
        })
    }
    
    fileprivate func initMorseKeyboardView() {
        self.morseKeyboardView = MorseKeyboardView()
        self.containerView?.addSubview(self.morseKeyboardView!)
        
        self.initMorseKeyboardViewConstraints()
    }
    
    fileprivate func initMorseKeyboardViewConstraints(_ height: CGFloat = 0) {
        self.morseKeyboardView?.snp.remakeConstraints({ [unowned self] make in
            make.top.equalTo(self.outputTextView!.snp.bottom).offset(Spacing.normal)
            make.left.equalTo(self.containerView!.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.containerView!.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(self.containerView!.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(height)
        })
    }
    
    fileprivate func initNavigationBarButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: nil, style: .plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: nil, style: .plain, target: nil, action: nil)
    }
    
    fileprivate func initBindings() {
        
        let input = self.initInputBindings()
        let output = self.viewModel.transform(input: input)
        self.initOutputBindings(output)
        self.initNavigationBarBinding()
        self.initTapToDissmissKeyboardBinding()
        self.initMorseKeyboardBindings()
    }
    
    fileprivate func initInputBindings() -> TranslateViewModel.Input {
        let inputTextDriver = self.inputTextView!.rx.text.orEmpty.changed.asDriver()
        let errorClickDriver = self.errorLabel!.rx
            .tapGesture()
            .flatMapLatest { _ in return Observable<Void>.just(Void()) }
            .asDriver(onErrorJustReturn: Void())
        let toggleModeDriver = self.navigationItem.leftBarButtonItem!.rx.tap
            .flatMapLatest { _ in return Observable<Void>.just(Void()) }
            .asDriver(onErrorJustReturn: Void())
        
        return TranslateViewModel.Input(text: inputTextDriver,
                                        removeUnknownCharacters: errorClickDriver,
                                        toggleMode: toggleModeDriver)
    }
    
    fileprivate func initOutputBindings(_ output: TranslateViewModel.Output) {
        output.unknownCharactersDriver
            .drive(onNext: { [weak self] characters in
                guard !characters.isEmpty else {
                    self?.errorLabel?.text = ""
                    return
                }
                self?.errorLabel?.text = "TranslateUnknownCharacters".localized(characters.sorted().joined(separator: ", "))
            })
            .disposed(by: self.bag)
        
        output.text
            .flatMapLatest({ output -> Driver<[NSAttributedString]> in
                switch output.translateMode.mode {
                case .textToMorse:
                    return .just(output.pairsResults.enumerated()
                        .map { NSAttributedString(text: $1.value,
                                                  textColor: .global($0.isMultiple(of: 2) ? .white: .clear),
                                                  fontSize: Sizes.outputTextFontSie)})
                case .morseToText:
                    return .just(output.pairsResults.enumerated()
                        .map { NSAttributedString(text: $1.key,
                                                  textColor: .global($0.isMultiple(of: 2) ? .white: .clear),
                                                  fontSize: Sizes.outputTextFontSie)})
                }
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
                self?.errorLabel?.text = "TranslateUnknownCharacters".localized(characters.sorted().joined(separator: ", "))
            })
            .disposed(by: self.bag)
        
        output.fixedText
            .drive(onNext: { [weak self] fixedText in
                self?.inputTextView?.text = fixedText
            })
            .disposed(by: self.bag)
        
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
        
        output.translateModes
            .drive(onNext: { [weak self] translateModes in
                guard let selectedMode = translateModes.first(where: { $0.isSelected }) else {
                    return
                }
                switch selectedMode.mode {
                case .morseToText:
                    self?.setMorseToTextView()
                case .textToMorse:
                    self?.setTextToMorseView()
                }
            })
            .disposed(by: self.bag)
        
        output.empty
            .drive()
            .disposed(by: self.bag)
    }
    
    fileprivate func initNavigationBarBinding() {
        self.navigationItem.rightBarButtonItem?.rx.tap
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                let controller = UINavigationController(rootViewController: DependencyContainer.resolve(AlphabetSelectionController.self))
                self?.navigationController?.present(controller, animated: true)
            })
            .disposed(by: self.bag)
    }
    
    fileprivate func initTapToDissmissKeyboardBinding() {
        self.containerView?.rx.tapGesture()
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: self.bag)
    }
    
    fileprivate func initMorseKeyboardBindings() {
        self.morseKeyboardView?.dotButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.inputTextView?.text.append("•")
            })
            .disposed(by: self.bag)
        
        self.morseKeyboardView?.dashButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.inputTextView?.text.append("—")
            })
            .disposed(by: self.bag)
        
        self.morseKeyboardView?.characterSpaceButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.inputTextView?.text.append(Pair.dividerSymbol)
            })
            .disposed(by: self.bag)
        
        self.morseKeyboardView?.spaceButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.inputTextView?.text.append(" ")
            })
            .disposed(by: self.bag)
        
        self.morseKeyboardView?.deleteButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let text = self?.inputTextView?.text.dropLast() else {
                    return
                }
                self?.inputTextView?.text = String(text)
            })
            .disposed(by: self.bag)
    }
    
    fileprivate func setMorseToTextView() {
        self.navigationItem.leftBarButtonItem?.image = .global(.text)
        self.inputTextView?.isEditable = false
        self.inputTextView?.resignFirstResponder()
        self.inputTextView?.text = ""
        UIView.animate(withDuration: 0.3) {
            self.initMorseKeyboardViewConstraints(Sizes.morseCodeKeyboardHeight)
            self.inputTextView?.superview?.layoutIfNeeded()
        }
    }
    
    fileprivate func setTextToMorseView() {
        self.navigationItem.leftBarButtonItem?.image = .global(.morseCode)
        self.inputTextView?.isEditable = true
        self.inputTextView?.text = ""
        UIView.animate(withDuration: 0.3) {
            self.initMorseKeyboardViewConstraints()
            self.inputTextView?.superview?.layoutIfNeeded()
        }
    }
    
    override func keyboardOpened(notification: Notification) {
        guard let height = notification.getKeyboardHeight(), let duration = notification.getKeyboardDuration() else {
            return
        }
        UIView.animate(withDuration: duration) { [weak self] in
            self?.initContainerViewConstraints(bottomOffset: -height)
            self?.view.layoutIfNeeded()
        }
    }
    
    override func keyboardHidden(notification: Notification) {
        guard let duration = notification.getKeyboardDuration() else {
            return
        }
        UIView.animate(withDuration: duration) { [weak self] in
            self?.initContainerViewConstraints()
            self?.view.layoutIfNeeded()
        }
    }
}
