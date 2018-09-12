//
//  TypeCollectionCell.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 9/10/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

class TypeCollectionCell: UICollectionViewCell {
    @IBOutlet weak var typeLabel: TypeLabel!
    @IBOutlet weak var damageLabel: UILabel!
    
    func setup(withType typing:Typing, damage:Float) {
        self.typeLabel.typing = typing
        
        if damage < Float(0.3) {
            self.damageLabel.text = "x" + String(format: "%.2f", damage)
        } else {
            self.damageLabel.text = "x" + String(format: "%.1f", damage)
        }
    }
}
