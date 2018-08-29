//
//  Defaults.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 8/29/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import Foundation

struct Defaults {
    static let generation = "Generation"
    static let versionGroup = "VersionGroup"
    
    static func setDefaults() {
        let defaultsURL = Bundle.main.url(forResource: "DefaultPreferences", withExtension: "plist")
        let dictionary  = NSDictionary(contentsOf: defaultsURL!) as! Dictionary<String, Any>
        UserDefaults.standard.register(defaults: dictionary)
    }
}
