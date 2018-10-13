//
//  TeamExtension.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 9/21/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import Foundation

extension Team {
    
    /// Returns an array (size 6) of Optional Team Pokemon.
    func getPokemon() -> [TeamPokemon?] {
        var arr:[TeamPokemon?] = Array(repeating: nil, count: 6)
        var i = 0
        for p in self.pokemon?.array as? [TeamPokemon] ?? [] {
            arr[i] = p
            i += 1
        }
        return arr
    }
}
