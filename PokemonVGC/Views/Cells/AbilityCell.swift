//
//  AbilityCell.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 9/9/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

class AbilityCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var effectLabel: UILabel!
    
    func setup(withAbility ability:PokemonAbility) {
        if ability.isHidden {
            self.nameLabel.text = (ability.ability?.getName(forLocale: "en") ?? "") + " (Hidden)"
        } else {
            self.nameLabel.text = ability.ability?.getName(forLocale: "en")
        }
        self.effectLabel.text = ability.ability?.getShortEffect(forLocale: "en")
    }
}
