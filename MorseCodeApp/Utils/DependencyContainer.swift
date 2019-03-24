//
//  ContainerExtension.swift
//  MorseCodeApp
//
//  Created by Mariusz Sut on 24/03/2019.
//  Copyright © 2019 Mariusz Sut. All rights reserved.
//

import Foundation
import Swinject
import RealmSwift

struct DependencyContainer {
    
    fileprivate static let container: Container = {
        return DependencyContainer.getContainer()
    }()
    
    fileprivate static func getContainer() -> Container {
        let container = Container()
        
        // MARK: Realm
        container.register(Realm.Configuration.self) { _  in
            var config = Realm.Configuration()
            config.schemaVersion = AppDefaults.schemeVersion
            return config
        }
        // MARK: Alphabet
        container.register(AlphabetRepositoryProtocol.self) { resolver in
            return AlphabetRepository(configuration: resolver.resolve(Realm.Configuration.self)!)
        }
        container.register(AlphabetViewModel.self) { resolver in
            return AlphabetViewModel(alphabetRepository: resolver.resolve(AlphabetRepositoryProtocol.self)!)
        }
        container.register(AlphabetController.self) { resolver in
            return AlphabetController(viewModel: resolver.resolve(AlphabetViewModel.self)!)
        }
        // MARK: Translate
        container.register(TranslateController.self) { _ in TranslateController() }
        // MARK: Settings
        container.register(SettingsController.self) { _ in SettingsController() }
        // MARK: About
        container.register(AboutController.self) { _ in AboutController() }
        // MARK: Main
        container.register(MainController.self) { _ in MainController() }
        return container
    }
    
    static func resolve<Service>(_ serviceType: Service.Type) -> Service {
        return DependencyContainer.container.resolve(serviceType)!
    }
}
