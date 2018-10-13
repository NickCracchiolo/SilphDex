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
    
    //// TODO: Use actual custom made tab bar icons. These are only temporary
    let pokedexTab = UITabBarItem(tabBarSystemItem: UITabBarItem.SystemItem.search, tag: 0)
    lazy var pokedexVC: UINavigationController = {
        let nav = UINavigationController()
        let vc = PokedexiOSViewController()
        vc.dataModel = self.dataModel
        vc.tabBarItem = self.pokedexTab
        nav.viewControllers.append(vc)
        return nav
    }()
    
    let visionTab = UITabBarItem(tabBarSystemItem: UITabBarItem.SystemItem.history, tag: 1)
    lazy var visionVC: UINavigationController = {
        let nav = UINavigationController()
        let vc = VisionViewController()
        vc.coreDataManager = self.coreDataManager
        vc.tabBarItem = self.visionTab
        nav.viewControllers.append(vc)
        return nav
    }()
    
    let teamBuildTab = UITabBarItem(tabBarSystemItem: UITabBarItem.SystemItem.contacts, tag: 2)
    lazy var teamBuildingVC: UINavigationController = {
        let nav = UINavigationController()
        let vc = TeamBuildingViewController()
        vc.coreDataManager = self.coreDataManager
        vc.tabBarItem = self.teamBuildTab
        nav.viewControllers.append(vc)
        return nav
    }()
    
    let settingsTab = UITabBarItem(tabBarSystemItem: UITabBarItem.SystemItem.more, tag: 3)
    lazy var settingsVC: UINavigationController = {
        let nav = UINavigationController()
        let vc = SettingsViewController()
        vc.tabBarItem = self.settingsTab
        nav.viewControllers.append(vc)
        return nav
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllers = [self.pokedexVC, self.visionVC, self.teamBuildingVC, self.settingsVC]
    }
    
}
