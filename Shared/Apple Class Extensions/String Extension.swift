//
//  String Extension.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 8/10/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import Foundation

extension String {
    func capitalize(letter l:Int) -> String {
        return prefix(l).uppercased() + dropFirst()
    }
    
    mutating func capitalize(letter l:Int) {
        self = self.capitalize(letter: l)
    }
}
