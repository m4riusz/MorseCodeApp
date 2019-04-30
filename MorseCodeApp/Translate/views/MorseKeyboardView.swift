//
//  MorseKeyboardView.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 29/04/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import UIKit

class MorseKeyboardView: BaseView {
    var stackView: UIStackView!
    var dotButton: UIButton!
    var dashButton: UIButton!
    var characterSpaceButton: UIButton!
    var spaceButton: UIButton!
    var deleteButton: UIButton!
    
    override func initialize() {
        super.initialize()
        self.initStackView()
        self.initDotButton()
        self.initDashButton()
        self.initCharacterSpaceButton()
        self.initSpaceButton()
        self.initDeleteButton()
    }
    
    fileprivate func initStackView() {
        self.stackView = UIStackView()
        self.stackView.axis = .horizontal
        self.stackView.distribution = .fillEqually
        self.addSubview(self.stackView)
        
        self.stackView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
    }
    
    fileprivate func initDotButton() {
        self.dotButton = UIButton()
        self.dotButton.setTitle("•", for: .normal)
        self.dotButton.backgroundColor = .gray
        self.stackView.addArrangedSubview(self.dotButton)
    }
    
    fileprivate func initDashButton() {
        self.dashButton = UIButton()
        self.dashButton.setTitle("—", for: .normal)
        self.dashButton.backgroundColor = .gray
        self.stackView.addArrangedSubview(self.dashButton)
    }
    
    fileprivate func initCharacterSpaceButton() {
        self.characterSpaceButton = UIButton()
        self.characterSpaceButton.setTitle("_", for: .normal)
        self.characterSpaceButton.backgroundColor = .gray
        self.stackView.addArrangedSubview(self.characterSpaceButton)
    }
    
    fileprivate func initDeleteButton() {
        self.deleteButton = UIButton()
        self.deleteButton.setTitle("CE", for: .normal)
        self.deleteButton.backgroundColor = .gray
        self.stackView.addArrangedSubview(self.deleteButton)
    }
    
    fileprivate func initSpaceButton() {
        self.spaceButton = UIButton()
        self.spaceButton.setTitle("<Space>", for: .normal)
        self.spaceButton.backgroundColor = .gray
        self.stackView.addArrangedSubview(self.spaceButton)
    }
}
