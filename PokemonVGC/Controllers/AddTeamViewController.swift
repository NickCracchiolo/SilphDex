//
//  AddTeamViewController.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 9/25/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

class AddTeamViewController: UITableViewController {
    var addingPokemon:Pokemon?
    var teams:[Team] = []
    var coreDataManager:CoreDataManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        self.teams = self.coreDataManager.getTeams()
    }
    
    private func registerCells() {
        self.tableView.register(UINib(nibName: TeamCell.identifier, bundle: nil), forCellReuseIdentifier: TeamCell.identifier)
        self.tableView.register(UINib(nibName: AddButtonCell.identifier, bundle: nil), forCellReuseIdentifier: AddButtonCell.identifier)
    }
}

extension AddTeamViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("ADD")
            
            break
        default:
            let t = teams[indexPath.row]
            if (t.pokemon?.count ?? 0) == 6 {
                let alert = UIAlertController(title: "Team Full!", message: "The team is already full, would you like to replace a Pokemon?", preferredStyle: .alert)
                let yes = UIAlertAction(title: "Yes", style: .default) { (action) in
                    // Go to the team and select a pokemon to replace
                }
                let no = UIAlertAction(title: "No", style: .cancel)
                alert.addAction(yes)
                alert.addAction(no)
                self.present(alert, animated: true, completion: nil)
            } else {
                let tp = TeamPokemon(context: self.coreDataManager.persistentContainer.viewContext)
                tp.pokemon = self.addingPokemon
                t.addToPokemon(tp)
                self.coreDataManager.saveContext()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.teams.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: AddButtonCell.identifier) as! AddButtonCell
            return cell
        default:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: TeamCell.identifier) as! TeamCell
            cell.setup(withTeam: teams[indexPath.row - 1])
            return cell
        }
    }
}
