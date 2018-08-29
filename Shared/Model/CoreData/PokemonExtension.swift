//
//  PokemonExtension.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 8/13/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import Foundation

extension Pokemon {
    func moves(forMethodName method:String) -> [PokemonMove] {
        let vg = UserDefaults.standard.integer(forKey: "VersionGroup")
        let mvs = self.moves?.allObjects as? [PokemonMove] ?? []
        print("Moves Count: \(mvs.count)")
        let vgMoves = mvs.filter { (m) -> Bool in
            let versions = m.versionGroupDetails?.allObjects as? [PokemonMoveVersion] ?? []
            print("Move Version Count: \(versions.count)")
            let filter = versions.filter({ (mv) -> Bool in
                return mv.versionGroup?.id ?? -1 == vg
            })
            print("Filtered Version Count: \(filter.count)")
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
