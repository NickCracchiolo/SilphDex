//
//  TypeLabel.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 8/11/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

class TypeLabel:UILabel {
    var typing:Typing = .normal {
        didSet {
            setup()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    func setup() {
        self.layer.cornerRadius = 5
        self.text = typing.name()
        self.backgroundColor = typing.color()
        self.textColor = UIColor.white
        self.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        self.clipsToBounds = true
    }
}

