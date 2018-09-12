//
//  Typing.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 8/11/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

enum Typing: String, CaseIterable, Codable {
    case normal
    case fighting
    case flying
    case poison
    case ground
    case rock
    case bug
    case ghost
    case steel
    case fire
    case water
    case grass
    case electric
    case psychic
    case ice
    case dragon
    case dark
    case fairy
    case shadow
    case unknown
    
    static let allCasesOrdered:[Typing] = [.normal, .fire, .water, .electric,
                                           .grass, .ice, .fighting, .poison,
                                           .ground, .flying, .psychic, .bug,
                                           .rock, .ghost, .dragon, .dark,
                                           .steel, .fairy, .shadow, .unknown]
    
    init(withName name:String) {
        switch name.lowercased() {
        case "normal":
            self = .normal
        case "grass":
            self = .grass
        case "fire":
            self = .fire
        case "poison":
            self = .poison
        case "flying":
            self = .flying
        case "dragon":
            self = .dragon
        case "water":
            self = .water
        case "bug":
            self = .bug
        case "dark":
            self = .dark
        case "psychic":
            self = .psychic
        case "ghost":
            self = .ghost
        case "electric":
            self = .electric
        case "rock":
            self = .rock
        case "ground":
            self = .ground
        case "fighting":
            self = .fighting
        case "ice":
            self = .ice
        case "steel":
            self = .steel
        case "fairy":
            self = .fairy
        case "shadow":
            self = .shadow
        default:
            self = .unknown
        }
    }
    
    func name() -> String {
        switch self {
        case .normal:
            return "Normal"
        case .grass:
            return "Grass"
        case .fire:
            return "Fire"
        case .poison:
            return "Poison"
        case .flying:
            return "Flying"
        case .dragon:
            return "Dragon"
        case .water:
            return "Water"
        case .bug:
            return "Bug"
        case .dark:
            return "Dark"
        case .psychic:
            return "Psychic"
        case .ghost:
            return "Ghost"
        case .electric:
            return "Electric"
        case .rock:
            return "Rock"
        case .ground:
            return "Ground"
        case .fighting:
            return "Fighting"
        case .ice:
            return "Ice"
        case .steel:
            return "Steel"
        case .fairy:
            return "Fairy"
        case .shadow:
            return "Shadow"
        case .unknown:
            return "???"
        }
    }
    
    func color() -> UIColor {
        switch self {
        case .normal:
            return UIColor(red: 167.0/255.0, green: 161.0/255.0, blue: 147.0/255.0, alpha: 1.0)
        case .grass:
            return UIColor(red: 142.0/255.0, green: 203.0/255.0, blue: 99.0/255.0, alpha: 1.0)
        case .fire:
            return UIColor(red: 231.0/255.0, green: 94.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        case .poison:
            return UIColor(red: 161.0/255.0, green: 96.0/255.0, blue: 157.0/255.0, alpha: 1.0)
        case .flying:
            return UIColor(red: 158.0/255.0, green: 174.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        case .dragon:
            return UIColor(red: 117.0/255.0, green: 104.0/255.0, blue: 223.0/255.0, alpha: 1.0)
        case .water:
            return UIColor(red: 80.0/255.0, green: 156.0/255.0, blue: 248.0/255.0, alpha: 1.0)
        case .bug:
            return UIColor(red: 177.0/255.0, green: 187.0/255.0, blue: 68.0/255.0, alpha: 1.0)
        case .dark:
            return UIColor(red: 112.0/255.0, green: 91.0/255.0, blue: 76.0/255.0, alpha: 1.0)
        case .psychic:
            return UIColor(red: 240.0/255.0, green: 124.0/255.0, blue: 164.0/255.0, alpha: 1.0)
        case .ghost:
            return UIColor(red: 98.0/255.0, green: 101.0/255.0, blue: 176.0/255.0, alpha: 1.0)
        case .electric:
            return UIColor(red: 248.0/255.0, green: 199.0/255.0, blue: 83.0/255.0, alpha: 1.0)
        case .rock:
            return UIColor(red: 186.0/255.0, green: 165.0/255.0, blue: 101.0/255.0, alpha: 1.0)
        case .ground:
            return UIColor(red: 205.0/255.0, green: 177.0/255.0, blue: 103.0/255.0, alpha: 1.0)
        case .fighting:
            return UIColor(red: 156.0/255.0, green: 86.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        case .ice:
            return UIColor(red: 118.0/255.0, green: 204.0/255.0, blue: 228.0/255.0, alpha: 1.0)
        case .steel:
            return UIColor(red: 173.0/255.0, green: 173.0/255.0, blue: 196.0/255.0, alpha: 1.0)
        case .fairy:
            return UIColor(red: 238.0/255.0, green: 185.0/255.0, blue: 243.0/255.0, alpha: 1.0)
        case .shadow:
            return UIColor(red: 93.0/255.0, green: 80.0/255.0, blue: 127.0/255.0, alpha: 1.0)
        case .unknown:
            return UIColor(red: 115.0/255.0, green: 158.0/255.0, blue: 145.0/255.0, alpha: 1.0)
        }
    }
}
