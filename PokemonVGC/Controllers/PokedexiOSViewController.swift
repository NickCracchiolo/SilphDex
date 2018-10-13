//
//  PokemonVGCViewController.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 8/29/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

protocol ForceTouchAlertDelegate: class {
    func didRecieveForceTouch(withObject obj:Any?)
}

class PokedexiOSViewController: UITableViewController {
    var adding:Bool = false
    var dataModel:PokedexDataModel!
    var pokedexNames:[String] = []
    let searchController:UISearchController = UISearchController(searchResultsController: nil)
    var searchResults:[PokemonSpeciesDexEntry]?
    var team:Team?
    
    
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
                guard let self = self else { return }
                let predicate = CoreDataManager.pokedexPredicate(forPokedex: n.lowercased())
                self.dataModel.updateController(ascending: true, key: "entryNumber", predicate: predicate)
                self.navigationItem.title = "\(n) Pokedex"
                DispatchQueue.main.async {
                    self.tableView.reloadData()
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
    
    @objc func cancelAction(_ sender:UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

    private func setupSearchController() {
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search for a Pokemon"
        self.searchController.searchBar.scopeButtonTitles = [PokedexScope.name.name(), PokedexScope.order.name(),
                                                        PokedexScope.type.name(), PokedexScope.baseStats.name()]
        self.searchController.searchBar.delegate = self
        self.searchController.isActive = true
        self.searchController.searchBar.autocorrectionType = .no
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
    }
    
    private func setupNavigationBar() {
        let pokedexBtn = UIBarButtonItem(title: "Pokedex", style: .plain, target: self, action: #selector(pokedex(_:)))
        if team != nil {
            let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction(_:)))
            self.navigationItem.leftBarButtonItems = [cancelBtn, pokedexBtn]
        } else {
            self.navigationItem.leftBarButtonItem = pokedexBtn
        }
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
        vc.coreDataManager = self.dataModel.coreDataManager
        vc.team = self.team
        if let results = searchResults {
            let s = results[indexPath.row].species!
            vc.species = s
            vc.pokemon = s.getDefaultVariety()!

        } else {
            let s = self.dataModel.fetchedResultsController.object(at: indexPath).species!
            vc.species = s
            vc.pokemon = s.getDefaultVariety()!
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
            cell.delegate = self
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

extension PokedexiOSViewController: ForceTouchAlertDelegate {
    func didRecieveForceTouch(withObject obj: Any?) {
        let gen = UIImpactFeedbackGenerator(style: .heavy)
        gen.prepare()
        if let dex = obj as? PokemonSpeciesDexEntry {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            for f in (dex.species?.getVarieties() ?? []).filter({!$0.isDefault}) {
                let action = UIAlertAction(title: f.pokemon?.name, style: .default) { [weak self] (action) in
                    guard let self = self else { return }
                    let vc = PokemonViewController()
                    vc.coreDataManager = self.dataModel.coreDataManager
                    vc.pokemon = f.pokemon!
                    vc.species = dex.species!
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                alert.addAction(action)
            }
            let addToTeam = UIAlertAction(title: "Add to Team", style: .default) { [weak self] (alert) in
                guard let self = self else { return }
                if let t = self.team {
                    let tp = TeamPokemon(context: self.dataModel.coreDataManager.persistentContainer.viewContext)
                    tp.pokemon = dex.species?.getDefaultVariety()
                    tp.level = 50
                    tp.name = dex.species?.getName(forLocale: "en")
                    for v in self.dataModel.coreDataManager.allIVs(withValue: 31) {
                        tp.addToIvs(v)
                    }
                    for v in self.dataModel.coreDataManager.allEVs(withValue: 0) {
                        tp.addToEvs(v)
                    }
                    t.addToPokemon(tp)
                    self.dataModel.coreDataManager.saveContext()
                    self.navigationController?.popViewController(animated: true)
                } else {
                    let vc = AddTeamViewController()
                    vc.coreDataManager = self.dataModel.coreDataManager
                    vc.addingPokemon = dex.species?.getDefaultVariety()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            alert.addAction(addToTeam)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
            alert.popoverPresentationController?.canOverlapSourceViewRect = true
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = self.view.bounds
            self.present(alert, animated: true, completion: nil)
            gen.impactOccurred()
        }
    }
}
