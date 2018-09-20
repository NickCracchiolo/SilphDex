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
        registerCells()
        setupSearchController()
        self.pokedexNames = dataModel.pokedexNames()
        pokedexNames.insert("National", at: 0)
        let predicate = CoreDataManager.pokedexPredicate(forPokedex: pokedexNames.first?.lowercased() ?? "national")
        setupNavigationBar()
        dataModel.updateController(ascending: true, key: "entryNumber", predicate: predicate)
    }
    
    @objc func pokedex(_ sender: UIBarButtonItem) {
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
    
    @objc func sort(_ sender:UIBarButtonItem) {
        
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
    
    private func setupNavigationBar() {
        let pokedexBtn = UIBarButtonItem(title: "Pokedex", style: .plain, target: self, action: #selector(pokedex(_:)))
        self.navigationItem.leftBarButtonItem = pokedexBtn
        let sortBtn = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(sort(_:)))
        self.navigationItem.rightBarButtonItem = sortBtn
        self.navigationItem.title = "\(pokedexNames.first ?? "National") Pokedex"
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func registerCells() {
        let nib = UINib(nibName: PokedexCell.identifier, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: PokedexCell.identifier)
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
        let vc = PokemonViewController()
        if let results = searchResults {
            vc.species = results[indexPath.row].species!
        } else {
            vc.species = self.dataModel.fetchedResultsController.object(at: indexPath).species!
        }
        self.navigationController?.pushViewController(vc, animated: true)
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
