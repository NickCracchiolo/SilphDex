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
    @IBOutlet weak var statBar: StatBar!
    
    func setup(forStat stat:PokemonStat) {
        let name = stat.stat?.abbr ?? ""
        self.nameLabel.text = name
        self.statLabel.text = "\(stat.baseStat)"
        if name.lowercased() == "total" {
            self.statBar.isHidden = true
        } else {
            let t = name.lowercased() == "hp" ? 714 : 669
            self.statBar.isHidden = false
            self.statBar.set(data: [Int(stat.baseStat)], total: t)
        }
    }
    
    func setup(forName name:String, value:Int) {
        self.nameLabel.text = name
        self.statLabel.text = "\(value)"
        if name.lowercased() == "total" {
            self.statBar.isHidden = true
        } else {
            let t = name.lowercased() == "hp" ? 714 : 669
            self.statBar.isHidden = false
            self.statBar.set(data: [value], total: t)
        }
    }
}
