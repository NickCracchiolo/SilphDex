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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for view in self.viewControllers ?? [] {
            if let navVC = view as? UINavigationController {
                if let vc = navVC.viewControllers.first as? PokedexiOSViewController {
                    vc.dataModel = PokedexDataModel(withCoreDataManager: self.coreDataManager)
                } else if let vc = view as? VisionViewController {
                    //vc.coreDataManager = coreDataManager
                }
            }
        }
    }
    
    
}
