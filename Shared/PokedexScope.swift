//
//  PokemonVGCScope.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 9/7/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import Foundation

enum PokedexScope {
    case name
    case order
    case type
    case baseStats
    
    init(withName name:String) {
        switch name {
        case "Order":
            self = .order
        case "Type":
            self = .type
        case "Stat Total":
            self = .baseStats
        default:
            self = .name
        }
    }
    
    func name() -> String {
        switch self {
        case .name:
            return "Name"
        case .order:
            return "Order"
        case .type:
            return "Type"
        case .baseStats:
            return "Stat Total"
        }
    }
}
