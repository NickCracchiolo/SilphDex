//
//  PokemonSpeciesExtension.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 8/13/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import Foundation

extension PokemonSpecies {
    func getName(forLocale local:String) -> String {
        if let n = (self.names?.allObjects as? [Name])?.first(where: { (n) -> Bool in
            return n.language?.name == local
        }) {
            return n.name!
        } else {
            return self.name!.capitalize(letter: 1)
        }
    }
    
    func getGenus(forLocale local:String) -> String? {
        if let g = (self.genera?.allObjects as? [Genus] ?? []).first(where: { (g) -> Bool in
            return g.language?.name == local
        }) {
            return g.genus
        } else {
            return nil
        }
    }
    
    func getVarieties() -> [PokemonSpeciesVariety] {
        return self.varieties?.allObjects as? [PokemonSpeciesVariety] ?? []
    }
    
    func getDefaultVariety() -> Pokemon? {
        if let pkmn = self.varieties?.allObjects as? [PokemonSpeciesVariety] {
            for p in pkmn {
                if p.isDefault {
                    return p.pokemon
                }
            }
        }
            return nil
    }
    
    func getEvolutionChain() -> [ChainLink] {
        var links:[ChainLink] = []
        var temp = self.evolutionChain?.chain
        
        while let t = temp {
            links.append(t)
            // TODO: Fix this for multiple evolution possibilities
            temp = (t.evolvesTo?.allObjects as? [ChainLink] ?? []).first
        }
        return links
    }
}
