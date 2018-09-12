//
//  PokemonExtension.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 8/13/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import Foundation

extension Pokemon {
    struct SortDescriptor {
        static let order = NSSortDescriptor(key: "order", ascending: true)
        static let name = NSSortDescriptor(key: "name", ascending: true)
        static let totalBaseStats = NSSortDescriptor(key: "totalBaseStats", ascending: true)
    }
    
    func getStats() -> [PokemonStat] {
        return self.stats?.allObjects as? [PokemonStat] ?? []
    }
    
    func getAbilities() -> [PokemonAbility] {
        return self.abilities?.allObjects as? [PokemonAbility] ?? []
    }
    
    func moves(forMethodName method:String) -> [PokemonMove] {
        let vg = UserDefaults.standard.integer(forKey: "VersionGroup")
        let mvs = self.moves?.allObjects as? [PokemonMove] ?? []
        let vgMoves = mvs.filter { (m) -> Bool in
            let versions = m.versionGroupDetails?.allObjects as? [PokemonMoveVersion] ?? []
            let filter = versions.filter({ (mv) -> Bool in
                return mv.versionGroup?.id ?? -1 == vg
            })
            return true
        }
        return vgMoves
    }
    
    func getSpecies() -> PokemonSpecies {
        if let s = species {
            return s
        } else {
            if let vars = self.varieties?.allObjects as? [PokemonSpeciesVariety],
                let v = vars.first {
                if let s = v.species {
                    print("has variety species")
                    return s
                } else {
                    print("Pokemon's variety has no species")
                }
            }
        }
        return species!
    }
    
    func baseStats() -> [String:Int16] {
        var dict:[String:Int16] = [:]
        if let set = self.stats, let sts = set.allObjects as? [PokemonStat] {
            for s in sts {
                if !s.stat!.isBattleOnly {
                    dict[s.stat!.name ?? ""] = s.baseStat
                }
            }
        }
        return dict
    }
}
