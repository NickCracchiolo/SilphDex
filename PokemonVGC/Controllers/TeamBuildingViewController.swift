//
//  TeamViewController.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 9/21/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

class TeamBuildingViewController: UITableViewController {
    var coreDataManager:CoreDataManager!
    var teams:[Team] = []
    var teamPokemon:[TeamPokemon] = []
    let headerTitles:[String] = ["Teams", "Created Pokemon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        addNavigationItems()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.teams = self.coreDataManager.getTeams()
        self.teamPokemon = self.coreDataManager.getTeamPokemon()
        self.tableView.reloadData()
    }
    
    private func registerCells() {
        self.tableView.register(UINib(nibName: TeamCell.identifier, bundle: nil), forCellReuseIdentifier: TeamCell.identifier)
        self.tableView.register(UINib(nibName: PokedexCell.identifier, bundle: nil), forCellReuseIdentifier: PokedexCell.identifier)
    }
    
    private func addNavigationItems() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked(_:)))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addButtonClicked(_ sender:UIBarButtonItem) {
        let alert = UIAlertController(title: "Add", message: nil, preferredStyle: .actionSheet)
        let newTeam = UIAlertAction(title: "Team", style: .default) { [weak self] (action) in
            guard let self = self else { return }
            let a2 = UIAlertController(title: "Name Your New Team", message: nil, preferredStyle: .alert)
            a2.addTextField(configurationHandler: nil)
            let next = UIAlertAction(title: "Next", style: .default, handler: { (action) in
                let name = a2.textFields?.first?.text ?? "New Team"
                let flow = UICollectionViewFlowLayout()
                flow.itemSize = CGSize(width: 87, height: 105)
                flow.scrollDirection = .vertical
                let vc = TeamViewController.init(collectionViewLayout: flow)
                vc.coreDataManager = self.coreDataManager
                let t = Team(context: self.coreDataManager.persistentContainer.viewContext)
                t.name = name
                self.coreDataManager.saveContext()
                vc.team = t
                self.navigationController?.pushViewController(vc, animated: true)
            })
            a2.addAction(next)
            self.present(a2, animated: true, completion: nil)
        }
        let newCompetativePokemon = UIAlertAction(title: "Pokemon", style: .default) { [weak self] (action) in
            guard let self = self else { return }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(newTeam)
        alert.addAction(newCompetativePokemon)
        alert.addAction(cancel)
        alert.popoverPresentationController?.barButtonItem = sender
        self.present(alert, animated: true, completion: nil)
    }
}

extension TeamBuildingViewController {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitles[section]
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let flow = UICollectionViewFlowLayout()
            flow.scrollDirection = .vertical
            let vc = TeamViewController.init(collectionViewLayout: flow)
            vc.coreDataManager = self.coreDataManager
            vc.team = teams[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = CompetativePokemonViewController()
            vc.teamPokemon = self.teamPokemon[indexPath.row]
            vc.coreDataManager = self.coreDataManager
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: // Section teams
            return teams.count
        case 1:
            return teamPokemon.count
        default:
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: TeamCell.identifier) as! TeamCell
            cell.setup(withTeam: teams[indexPath.row])
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: PokedexCell.identifier) as! PokedexCell
            cell.setup(withPokemon: teamPokemon[indexPath.row].pokemon!)
            return cell
        default:
            return UITableViewCell()
        }
    }
}
