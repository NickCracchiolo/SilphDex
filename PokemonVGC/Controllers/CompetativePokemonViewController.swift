//
//  CompetativePokemonViewController.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 10/12/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

fileprivate enum Sections:Int, CaseIterable {
    case info
    case damageRelations
    case ability
    case nature
    case stats
    case moves
    
    func name() -> String? {
        switch self {
        case .damageRelations:
            return "Damage Relations"
        case .ability:
            return "Ability"
        case .nature:
            return "Nature"
        case .stats:
            return "Stats"
        case .moves:
            return "Moves"
        default:
            return nil
        }
    }
    
    func numberOfRows() -> Int {
        switch self {
        case .info:
            return 1
        case .damageRelations:
            return 1
        case .ability:
            return 1
        case .nature:
            return 1
        case .stats:
            return 1
        case .moves:
            return 4
        }
    }
}

fileprivate enum CollectionViews:Int {
    case damageRelations
    case stats
}

class CompetativePokemonViewController: UITableViewController {
    var team:Team! // Maybe dont need
    var teamPokemon:TeamPokemon!
    var coreDataManager:CoreDataManager!
    var typeDamages:[String:Float] = [:]
    let orderedTypes = Typing.allCasesOrdered
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        let types = self.teamPokemon.pokemon?.types?.allObjects as? [PokemonType] ?? []
        self.typeDamages = DamageCalculator.calculateMultipliers(forType1: types[0].type!, t2: types.last?.type)
    }
    
    private func registerCells() {
        self.tableView.register(UINib(nibName: PokemonSpriteCell.identifier, bundle: nil), forCellReuseIdentifier: PokemonSpriteCell.identifier)
        self.tableView.register(UINib(nibName: CollectionCell.identifier, bundle: nil), forCellReuseIdentifier: CollectionCell.identifier)
    }
    
    private func addNavigationButtons() {
        self.navigationItem.title = self.teamPokemon.name
        let saveBtn = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(savePokemon(_:)))
        self.navigationItem.rightBarButtonItems = [saveBtn]
    }
    
    private func setup() {
        
    }
    
    @objc func savePokemon(_ sender:UIBarButtonItem) {
        self.coreDataManager.saveContext()
    }
    
}

extension CompetativePokemonViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let s = Sections(rawValue: indexPath.section) {
            switch s {
            case .nature:
                let vc = NaturesViewController()
                vc.coreDataManager = self.coreDataManager
                self.navigationController?.present(vc, animated: true, completion: nil)
            default:
                break
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let s = Sections(rawValue: section) {
            return s.numberOfRows()
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let s = Sections(rawValue: section) {
            return s.name()
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let s = Sections(rawValue: indexPath.section) else { return UITableViewCell() }
        switch s {
        case .info:
            let cell = tableView.dequeueReusableCell(withIdentifier: PokemonSpriteCell.identifier) as! PokemonSpriteCell
            cell.setup(forPokemon: teamPokemon.pokemon!)
            return cell
        case .damageRelations:
            let cell = tableView.dequeueReusableCell(withIdentifier: CollectionCell.identifier) as! CollectionCell
            cell.setup(withDelegate: self, dataSource: self, tag: CollectionViews.damageRelations.rawValue, cellId: TypeCollectionCell.identifier)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension CompetativePokemonViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let col = CollectionViews(rawValue: collectionView.tag) {
            switch col {
            case .damageRelations:
                return 1
            case .stats:
                return 3
            }
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let col = CollectionViews(rawValue: collectionView.tag) {
            switch col {
            case .damageRelations:
                return
            case .stats:
                return
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let col = CollectionViews(rawValue: collectionView.tag) {
            switch col {
            case .damageRelations:
                return Typing.allCases.count
            case .stats:
                return 6
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let col = CollectionViews(rawValue: collectionView.tag) {
            switch col {
            case .damageRelations:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TypeCollectionCell.identifier, for: indexPath) as! TypeCollectionCell
                let type = orderedTypes[indexPath.row]
                let dmg = self.typeDamages[type.rawValue] ?? 1.0
                cell.setup(withType: type, damage: dmg)
                return cell
            case .stats:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatEntryCell.identifier, for: indexPath) as! StatEntryCell
                cell.setup(withDelegate: self, value: 31)
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let col = CollectionViews(rawValue: collectionView.tag) {
            switch col {
            case .damageRelations:
                return CGSize(width: 86, height: 60)
            case .stats:
                return CGSize(width: 87, height: 105)
            }
        }
        return CGSize.zero
    }
}

extension CompetativePokemonViewController: UITextFieldDelegate {
    
}
