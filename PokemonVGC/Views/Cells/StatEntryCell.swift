//
//  StatEntryCell.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 10/12/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

class StatEntryCell: UICollectionViewCell {
    @IBOutlet weak var field: UITextField!
    
    func setup(withDelegate delegate:UITextFieldDelegate, value:Int) {
        self.field.delegate = delegate
        self.field.text = "\(value)"
    }
}
