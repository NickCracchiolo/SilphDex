//
//  TeamCell.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 9/21/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

class TeamCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    //@IBOutlet weak var winLossLabel: UILabel!
    @IBOutlet weak var sprite1: UIImageView!
    @IBOutlet weak var sprite2: UIImageView!
    @IBOutlet weak var sprite3: UIImageView!
    @IBOutlet weak var sprite4: UIImageView!
    @IBOutlet weak var sprite5: UIImageView!
    @IBOutlet weak var sprite6: UIImageView!
    
    func setup(withTeam team:Team) {
        self.nameLabel.text = team.name
        let pkmn = team.getPokemon()
        for i in 0..<6 {
            if let poke = pkmn[i], let img = poke.pokemon?.sprites?.frontDefault {
                switch i {
                case 0:
                    sprite1.isHidden = false
                    sprite1.image = UIImage(data: img)!
                case 1:
                    sprite2.isHidden = false
                    sprite2.image = UIImage(data: img)!
                case 2:
                    sprite3.isHidden = false
                    sprite3.image = UIImage(data: img)!
                case 3:
                    sprite4.isHidden = false
                    sprite4.image = UIImage(data: img)!
                case 4:
                    sprite5.isHidden = false
                    sprite5.image = UIImage(data: img)!
                case 5:
                    sprite6.isHidden = false
                    sprite6.image = UIImage(data: img)!
                default:
                    break
                }
            } else {
                switch i {
                case 0:
                    sprite1.isHidden = true
                case 1:
                    sprite2.isHidden = true
                case 2:
                    sprite3.isHidden = true
                case 3:
                    sprite4.isHidden = true
                case 4:
                    sprite5.isHidden = true
                case 5:
                    sprite6.isHidden = true
                default:
                    break
                }
            }
        }
    }
}
