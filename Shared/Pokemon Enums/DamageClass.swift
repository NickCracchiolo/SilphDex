//
//  DamageClass.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 9/11/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import Foundation

enum DamageClass {
    case special
    case physical
    case status
    
    init(withName name:String) {
        switch name {
        case "special":
            self = .special
        case "physical":
            self = .physical
        default:
            self = .status
        }
    }
}
