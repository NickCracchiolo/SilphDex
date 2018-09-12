//
//  StatCell.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 9/11/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

class StatCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statLabel: UILabel!
    
    func setup(forStat stat:PokemonStat) {
        self.nameLabel.text = stat.stat?.getName(forLocale: "en")
        self.statLabel.text = "\(stat.baseStat)"
    }
    
    func setup(forName name:String, value:Int) {
        self.nameLabel.text = name
        self.statLabel.text = "\(value)"
    }
}
