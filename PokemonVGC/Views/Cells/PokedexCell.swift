//
//  PokemonVGCCell.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 9/5/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

class PokedexCell: UITableViewCell {
    weak var delegate:ForceTouchAlertDelegate?
    weak var dex:PokemonSpeciesDexEntry?
    @IBOutlet weak var spriteView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sortLabel: UILabel!
    @IBOutlet weak var type1Label: TypeLabel!
    @IBOutlet weak var type2Label: TypeLabel!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Cell touched")
        if let touch = touches.first {
            print("Touch Force: \(touch.force)")

            if touch.force > 2.0 {
                self.delegate?.didRecieveForceTouch(withObject: self.dex)
            } else {
                super.touchesBegan(touches, with: event)
            }
            
        }
    }
    
    func setup(withDexEntry dex:PokemonSpeciesDexEntry) {
        self.dex = dex
        let species = dex.species!
        self.nameLabel.text = species.getName(forLocale: "en")
        let defaultPokemon = species.getDefaultVariety()
        if let front = defaultPokemon?.sprites?.frontDefault {
            self.spriteView.image = UIImage(data: front)
        }
        self.sortLabel.text = "\(dex.entryNumber)"
        if let pokemon = defaultPokemon {
            self.type1Label.isHidden = false
            self.type2Label.isHidden = false
            setupTypes(withTypes: pokemon.getTypes())
        } else {
            hideTypeLabels()
        }
    }
    
    func setup(withPokemon p:Pokemon) {
        self.nameLabel.text = p.name?.capitalize(letter: 1)
        if let front = p.sprites?.frontDefault {
            self.spriteView.image = UIImage(data: front)
        }
        setupTypes(withTypes: p.getTypes())
        self.sortLabel.isHidden = true
    }
    
    private func setupTypes(withTypes types:[PokemonType]) {
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
    }
    private func hideTypeLabels() {
        self.type1Label.isHidden = true
        self.type2Label.isHidden = true
    }
}
