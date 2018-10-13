//
//  FormCollectionCell.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 9/9/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

class FormCollectionCell: UICollectionViewCell {
    @IBOutlet weak var spriteView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    func setup(withVariety variety: PokemonSpeciesVariety) {
        if let p = variety.pokemon {
            if let front = p.sprites?.frontDefault {
                self.spriteView.image = UIImage(data: front)
            }
            self.nameLabel.text = p.name
        }
    }
    
    func setup(withSpecies species:PokemonSpecies?) {
        if let p = species?.getDefaultVariety() {
            if let front = p.sprites?.frontDefault {
                self.spriteView.image = UIImage(data: front)
            }
            self.nameLabel.text = p.name
        } else {
            self.spriteView.image = nil
            self.nameLabel.text = "--"
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backView.layer.cornerRadius = 5.0
        backView.layer.borderWidth = 2.0
        backView.layer.borderColor = UIColor.black.cgColor
    }
}
