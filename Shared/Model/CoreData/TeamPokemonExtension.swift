//
//  TeamPokemonExtension.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 8/25/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import Foundation

extension TeamPokemon {
    func allIvs() -> [String:Int16] {
        var dict:[String:Int16] = [:]
        if let set = self.ivs, let sts = set.allObjects as? [PokemonIV] {
            for s in sts {
                if !s.stat!.isBattleOnly {
                    dict[s.stat!.name ?? ""] = s.value
                }
            }
        }
        return dict
    }
    func allEvs() -> [String:Int16] {
        var dict:[String:Int16] = [:]
        if let set = self.evs, let sts = set.allObjects as? [PokemonIV] {
            for s in sts {
                if !s.stat!.isBattleOnly {
                    dict[s.stat!.name ?? ""] = s.value
                }
            }
        }
        return dict
    }
    func calculateStatTotals() -> [String:Int] {
        var dict:[String:Int] = [:]
        let baseStats = self.pokemon!.baseStats()
        let ivStats = self.allIvs()
        let evStats = self.allEvs()
        let gen = UserDefaults.standard.integer(forKey: "Generation")
        //Stat array used for looping over the other stats besides hp and to allow hashing into dictionary
        let otherStats = ["attack", "defense", "special-attack", "special-defense", "speed"]
        let baseHP = baseStats["hp"] ?? 0, ivHP = ivStats["hp"] ?? 31, evHP = evStats["hp"] ?? 0
        dict["hp"] = hpStatValue(forBase: baseHP, iv: ivHP, ev: evHP, gen: gen)
        for s in otherStats {
            let base = baseStats[s] ?? 0, iv = ivStats[s] ?? 31, ev = evStats[s] ?? 0
            dict[s] = otherStatValue(forBase: base, iv: iv, ev: ev, gen: gen, statName: s)
        }
        return dict
    }
    
    private func hpStatValue(forBase base:Int16, iv:Int16, ev:Int16, gen:Int) -> Int {
        if gen < 3 {
            let x = (Double(base + iv) * 2.0)
            let y = floor(sqrt(Double(ev)) / 4.0)
            let z = x + y
            return Int(floor(z * Double(self.level) / 100.0)) + Int(level) + 10
        } else {
            let x = (Double(base + iv) * 2.0)
            let y = floor(sqrt(Double(ev)) / 4.0)
            let z = x + y
            return Int(floor(z * Double(self.level) / 100.0)) + 5
        }
    }
    private func otherStatValue(forBase base:Int16, iv:Int16, ev:Int16, gen:Int, statName:String) -> Int {
        if gen < 3 {
            let x = 2.0 * Double(base) + Double(iv)
            let y = floor(sqrt(Double(ev)) / 4.0)
            let z = (x + y) * Double(level) / 100.0
            return Int(floor(z)) + Int(level) + 10
        } else {
            let x = 2.0 * Double(base) + Double(iv)
            let y = floor(sqrt(Double(ev)) / 4.0)
            let z = (x + y) * Double(level) / 100.0
            let a = floor(z) + 5.0
            if (nature?.decreasedStats?.allObjects as? [NatureStatAffectSets] ?? []).contains(where: { $0.stat?.name == statName }) {
                return Int(floor(a * 0.9))
            }
            if (nature?.increasedStats?.allObjects as? [NatureStatAffectSets] ?? []).contains(where: { $0.stat?.name == statName }) {
                return Int(floor(a * 1.1))
            }
            return Int(a)
        }
    }
}
