//
//  PokemonVGCViewController.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 8/29/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

class PokedexiOSViewController: UITableViewController {
    
    var dataModel:PokedexDataModel!
    var pokedexNames:[String] = []
    let searchController:UISearchController = UISearchController(searchResultsController: nil)
    var searchResults:[PokemonSpeciesDexEntry]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "PokedexCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: PokedexCell.identifier)
        setupSearchController()
        self.pokedexNames = dataModel.pokedexNames()
        pokedexNames.insert("National", at: 0)
        let predicate = CoreDataManager.pokedexPredicate(forPokedex: pokedexNames.first?.lowercased() ?? "national")
        self.navigationItem.title = "\(pokedexNames.first ?? "National") Pokedex"
        dataModel.updateController(ascending: true, key: "entryNumber", predicate: predicate)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokedexToPokemonSegue" {
            if let vc = segue.destination as? PokemonViewController, let i = self.tableView.indexPathForSelectedRow {
                if let results = searchResults {
                    vc.species = results[i.row].species!
                } else {
                    vc.species = self.dataModel.fetchedResultsController.object(at: i).species!
                }
                    
            }
        }
    }
    
    @IBAction func pokedex(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Pokedex", message: "Select a specific pokedex for this generation.", preferredStyle: .actionSheet)
        
        for n in pokedexNames {
            let action = UIAlertAction(title: n, style: .default) { [weak self] (action) in
                guard let s = self else { return }
                let predicate = CoreDataManager.pokedexPredicate(forPokedex: n.lowercased())
                s.dataModel.updateController(ascending: true, key: "entryNumber", predicate: predicate)
                s.navigationItem.title = "\(n) Pokedex"
                DispatchQueue.main.async {
                    s.tableView.reloadData()
                }
            }
            alert.addAction(action)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancel)
        alert.popoverPresentationController?.barButtonItem = sender
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setupSearchController() {
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search Pokemon"
        self.searchController.searchBar.scopeButtonTitles = [PokedexScope.name.name(), PokedexScope.order.name(),
                                                        PokedexScope.type.name(), PokedexScope.baseStats.name()]
        self.searchController.searchBar.delegate = self
        self.searchController.isActive = true
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
    }
    
    func isSearchBarEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func filterContents(forSearchString str:String, scope: PokedexScope) {
        if let pkmn = self.dataModel.fetchedResultsController.fetchedObjects {
            self.searchResults = pkmn.filter({ (p) -> Bool in
                switch scope {
                case .order:
                    return p.entryNumber == (Int(str) ?? -1)
                case .type:
                    var hasType = false
                    for v in p.species?.varieties?.allObjects as? [PokemonSpeciesVariety] ?? [] {
                        for t in v.pokemon?.types?.allObjects as? [PokemonType] ?? [] {
                            if t.type?.name?.lowercased().hasPrefix(str.lowercased()) ?? false {
                                hasType = true
                            }
                        }
                    }
                    return hasType
                case .baseStats:
                    let p = (p.species?.pokemon?.allObjects as? [Pokemon] ?? []).first
                    return p?.totalBaseStats ?? 0 > Int16(str) ?? 0
                default:
                    return p.species?.name!.lowercased().range(of: str.lowercased()) != nil
                }
            })
            
            self.tableView.reloadData()
        }
    }
}

extension PokedexiOSViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "PokedexToPokemonSegue", sender: nil)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let results = searchResults {
            return results.count
        }
        return dataModel.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PokedexCell.identifier) as? PokedexCell {
            var dex:PokemonSpeciesDexEntry?
            if let d = searchResults?[indexPath.row] {
                dex = d
            } else {
                dex = self.dataModel.fetchedResultsController.object(at: indexPath)
            }
            cell.setup(withDexEntry: dex!)
            return cell
        }
        return UITableViewCell()
    }
}

extension PokedexiOSViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            let scopeStr = searchController.searchBar.scopeButtonTitles![searchController.searchBar.selectedScopeButtonIndex]
            let scope = PokedexScope.init(withName: scopeStr)
            filterContents(forSearchString: text, scope: scope)
        } else {
            searchResults = nil
        }
    }
}

extension PokedexiOSViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResults = nil
        self.tableView.reloadData()
    }
}
