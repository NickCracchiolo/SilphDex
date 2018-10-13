//
//  MoveCell.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 9/9/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

class MoveCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: TypeLabel!
    @IBOutlet weak var damageClassView: UIView!
    @IBOutlet weak var ppLabel: UILabel!
    @IBOutlet weak var powerLabel: UILabel!
    @IBOutlet weak var accuracyLabel: UILabel!
    
    func setup(withMove move:PokemonMove) {
        self.nameLabel.text = move.move?.getName(forLocale: "en")
        self.typeLabel.typing = Typing(withName: move.move?.type?.name ?? "normal")
        let dmgClass = DamageClass(withName: move.move?.damageClass?.name ?? "status")
        damageClassView.backgroundColor = dmgClass.color()
        if let pp = move.move?.pp, pp >= 0 {
            self.ppLabel.text = "PP: \(pp)"
        } else {
            self.ppLabel.text = "PP: --"
        }
        if let power = move.move?.power, power >= 0 {
            self.powerLabel.text = "Power: \(power)"
        } else {
            self.powerLabel.text = "Power: --"
        }
        if let acc = move.move?.accuracy, acc >= 0 {
            self.accuracyLabel.text = "Acc: \(acc)"
        } else {
            self.accuracyLabel.text = "Acc: --"
        }
    }
}
