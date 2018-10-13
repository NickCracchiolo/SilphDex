//
//  MLM.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 10/11/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import Foundation

/// Enum for Move Learn Methods for string sort and fetch descriptors
enum MLM: Int, CaseIterable {
    case levelUp = 1
    case egg = 2
    case tutor = 3
    case machine = 4
    case stadiumSurfingPikachu = 5
    case lightBallEgg = 6
    case formChange = 10
    
    func name() -> String {
        switch self {
        case .levelUp:
            return "level-up"
        case .egg:
            return "egg"
        case .tutor:
            return "tutor"
        case .machine:
            return "machine"
        case .stadiumSurfingPikachu:
            return "stadium-surfing-pikachu"
        case .lightBallEgg:
            return "light-ball-egg"
        case .formChange:
            return "form-change"
        }
    }
    func displayName() -> String {
        switch self {
        case .levelUp:
            return "Level Up"
        case .egg:
            return "Egg"
        case .tutor:
            return "Tutor"
        case .machine:
            return "Machine"
        case .stadiumSurfingPikachu:
            return "Stadium Surfing Pikachu"
        case .lightBallEgg:
            return "Light Ball Egg"
        case .formChange:
            return "Form Change"
        }
    }
}
