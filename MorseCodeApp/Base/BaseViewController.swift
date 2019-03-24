//
//  BaseViewController.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 20/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import UIKit

class BaseViewController<T: ViewModelType>: UIViewController {
    internal let viewModel: T!
    
    init(viewModel: T) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadScreenData()
    }
    
    open func initialize() {
        
    }
    
    open func loadScreenData() {
        
    }
}
