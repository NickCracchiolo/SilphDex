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
    
    func setup(withDexEntry dex:PokemonSpeciesDexEntry) {
        let species = dex.species!
        self.nameLabel.text = species.getName(forLocale: "en")
        if let front = species.getDefaultVariety()?.sprites?.frontDefault {
            self.spriteView.image = UIImage(data: front)
        }
        self.sortLabel.text = "\(dex.entryNumber)"
    }
}
