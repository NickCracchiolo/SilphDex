//
//  NatureCell.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 10/13/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

class NatureCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var increaseLabel: UILabel!
    @IBOutlet weak var decreaseLabel: UILabel!
    
    func setup(forNature nature:Nature) {
        self.nameLabel.text = nature.getName(forLocale: "en")
        if let i = nature.increasedStats?.allObjects as? [NatureStatAffectSets],
            let d = nature.decreasedStats?.allObjects as? [NatureStatAffectSets], i.count > 0, d.count > 0 {
            self.increaseLabel.text = (i[0].stat?.abbr ?? "") + "+"
            self.increaseLabel.textColor = .green
            self.decreaseLabel.text = (d[0].stat?.abbr ?? "") + "-"
            self.decreaseLabel.textColor = .red
        } else {
            self.increaseLabel.text = ""
            self.increaseLabel.textColor = .black
            self.decreaseLabel.text = "Neutral"
            self.decreaseLabel.textColor = .black
        }
    }
}
