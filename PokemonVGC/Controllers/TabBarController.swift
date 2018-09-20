//
//  TabBarController.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 9/7/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    var coreDataManager:CoreDataManager!
    lazy var dataModel = PokedexDataModel(withCoreDataManager: self.coreDataManager)
    
    lazy var pokedexTab: UINavigationController = {
        let nav = UINavigationController()
        let vc = PokedexiOSViewController()
        vc.dataModel = self.dataModel
        nav.viewControllers.append(vc)
        return nav
    }()
    
    lazy var visionTab: UINavigationController = {
        let nav = UINavigationController()
        let vc = VisionViewController()
        vc.coreDataManager = self.coreDataManager
        nav.viewControllers.append(vc)
        return nav
    }()
    
    lazy var settingsTab: UINavigationController = {
        let nav = UINavigationController()
        let vc = SettingsViewController()
        nav.viewControllers.append(vc)
        return nav
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = [self.pokedexTab, self.visionTab, self.settingsTab]
    }
    
}
