//
//  AbilityExtension.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 9/11/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import Foundation

extension Ability {
    func getName(forLocale locale:String) -> String {
        if let n = (self.names?.allObjects as? [Name])?.first(where: { (n) -> Bool in
            return n.language?.name == locale
        }) {
            return n.name!
        } else {
            return self.name!.capitalize(letter: 1)
        }
    }
    
    func getShortEffect(forLocale locale:String) -> String? {
        if let effects = self.effectEntries?.allObjects as? [VerboseEffect] {
            return effects.first(where: { $0.language?.name == locale })?.shortEffect
        }
        return nil
    }
    
    func getEffect(forLocale locale:String) -> String? {
        if let effects = self.effectEntries?.allObjects as? [VerboseEffect] {
            return effects.first(where: { $0.language?.name == locale })?.effect
        }
        return nil
    }
}
