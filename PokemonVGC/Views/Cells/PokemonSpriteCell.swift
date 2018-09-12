//
//  PokemonSpriteCell.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 9/9/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

class PokemonSpriteCell: UITableViewCell {
    @IBOutlet weak var frontView: UIImageView!
    @IBOutlet weak var backView: UIImageView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    func setup(forPokemon poke:Pokemon) {
        segmentControl.setTitle("Default", forSegmentAt: 0)
        segmentControl.setTitle("Female", forSegmentAt: 1)

        if let sprites = poke.sprites {
            if let front = sprites.frontDefault {
                self.frontView.image = UIImage(data: front)
            }
            if let back = sprites.backDefault {
                self.backView.image = UIImage(data: back)
            }
        }
    }
}
