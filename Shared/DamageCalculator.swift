//
//  DamageCalculator.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 9/11/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import Foundation

struct DamageCalculator {
    static func calculateMultipliers(forType1 t1:Type, t2:Type?) -> [String:Float] {
        var types:[String:Float] = [:]
        for t in Typing.allCases {
            types[t.name().lowercased()] = 1.0
        }
        if let dmgs = t1.damageRelations {
            for t in dmgs.noDamageFrom?.allObjects as? [Type] ?? [] {
                if let _ = types[t.name ?? ""] {
                    types[t.name ?? ""] = 0.0
                } else {
                    types[t.name ?? ""] = 0.0
                }
            }
            for t in dmgs.halfDamageFrom?.allObjects as? [Type] ?? [] {
                if let count = types[t.name ?? ""] {
                    types[t.name ?? ""] = count * 0.5
                } else {
                    types[t.name ?? ""] = 0.5
                }
            }
            for t in dmgs.doubleDamageFrom?.allObjects as? [Type] ?? [] {
                if let count = types[t.name ?? ""] {
                    types[t.name ?? ""] = count * 2.0
                } else {
                    types[t.name ?? ""] = 2.0
                }
            }
        }
        
        if let type = t2, let dmgs = type.damageRelations {
            for t in dmgs.noDamageFrom?.allObjects as? [Type] ?? [] {
                if let _ = types[t.name ?? ""] {
                    types[t.name ?? ""] = 0.0
                } else {
                    types[t.name ?? ""] = 0.0
                }
            }
            for t in dmgs.halfDamageFrom?.allObjects as? [Type] ?? [] {
                if let count = types[t.name ?? ""] {
                    types[t.name ?? ""] = count * 0.5
                } else {
                    types[t.name ?? ""] = 0.5
                }
            }
            for t in dmgs.doubleDamageFrom?.allObjects as? [Type] ?? [] {
                if let count = types[t.name ?? ""] {
                    types[t.name ?? ""] = count * 2.0
                } else {
                    types[t.name ?? ""] = 2.0
                }
            }
        }
        return types
    }
}
