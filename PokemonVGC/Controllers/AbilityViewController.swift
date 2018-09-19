//
//  AbilityViewController.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 9/19/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

class AbilityViewController: UITableViewController {
    var ability:Ability!
    lazy var pokemon:[PokemonAbility] = self.ability.getPokemon()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "PokedexCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: PokedexCell.identifier)
        self.navigationItem.title = self.ability.getName(forLocale: "en")
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return pokemon.count
        default:
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return self.tableView.estimatedRowHeight
        case 1:
            return 72
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: EffectCell.identifier) as! EffectCell
            cell.effectLabel.text = self.ability.getEffect(forLocale: "en")
            return cell
        case 1:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: PokedexCell.identifier) as! PokedexCell
            cell.setup(withPokemon: self.pokemon[indexPath.row].pokemon!)
            return cell
        default:
            return UITableViewCell()
        }
    }
}
