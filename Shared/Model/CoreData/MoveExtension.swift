//
//  MoveExtension.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 9/11/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import Foundation

extension Move {
    func getName(forLocale locale:String) -> String {
        if let n = (self.names?.allObjects as? [Name])?.first(where: { (n) -> Bool in
            return n.language?.name == locale
        }) {
            return n.name!
        } else {
            return self.name!.capitalize(letter: 1)
        }
    }
}
