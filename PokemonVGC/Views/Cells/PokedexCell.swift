//
//  PokemonVGCCell.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 9/5/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

class PokedexCell: UITableViewCell {
    @IBOutlet weak var spriteView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sortLabel: UILabel!
    @IBOutlet weak var type1Label: TypeLabel!
    @IBOutlet weak var type2Label: TypeLabel!
    
    func setup(withDexEntry dex:PokemonSpeciesDexEntry) {
        let species = dex.species!
        self.nameLabel.text = species.getName(forLocale: "en")
        if let front = species.getDefaultVariety()?.sprites?.frontDefault {
            self.spriteView.image = UIImage(data: front)
        }
        self.sortLabel.text = "\(dex.entryNumber)"
        if let pokemon = species.getDefaultVariety() {
            self.type1Label.isHidden = false
            self.type2Label.isHidden = false
            let types = pokemon.getTypes()
            if types.count > 0 {
                self.type1Label.typing = Typing(withName: types[0].type?.name ?? "normal")
                if types.count > 1 {
                    if let type2 = types[1].type?.name {
                        self.type2Label.typing = Typing(withName: type2)
                    } else {
                        self.type2Label.isHidden = true
                    }
                } else {
                    self.type2Label.isHidden = true
                }
            } else {
                hideTypeLabels()
            }
        } else {
            hideTypeLabels()
        }
    }
    private func hideTypeLabels() {
        self.type1Label.isHidden = true
        self.type2Label.isHidden = true
    }
}
