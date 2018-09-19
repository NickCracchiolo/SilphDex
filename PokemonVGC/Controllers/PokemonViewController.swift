//
//  PokemonViewController.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 9/8/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

class PokemonViewController: UITableViewController {
    
    private enum CollectionViews:Int {
        case forms
        case damageRelations
        case evolutions
    }
    
    private enum Sections:Int, CaseIterable {
        case info
        case damageRelations
        case evolutions
        case abilities
        case baseStats
        case moves
        
        func name() -> String? {
            switch self {
            case .damageRelations:
                return "Damage Relations"
            case .evolutions:
                return "Evolution Chain"
            case .abilities:
                return "Abilities"
            case .baseStats:
                return "Base Stats"
            default:
                return nil
            }
        }
    }
    
    var moveSegmentControl: UISegmentedControl = {
        let seg = UISegmentedControl()
        return seg
    }()
    
    var species:PokemonSpecies!
    var pokemon:Pokemon!
    var varieties:[PokemonSpeciesVariety] = []
    var abilities:[PokemonAbility] = []
    var moves:[PokemonMove] = []
    var stats:[PokemonStat] = []
    var evolutions:[ChainLink] = []
    var typeDamages:[String:Float] = [:]
    let orderedTypes = Typing.allCasesOrdered
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pokemon = species.getDefaultVariety()!
        self.varieties = species.getVarieties()
        self.abilities = pokemon.getAbilities()
        self.moves = pokemon.moves(forMethodName: "level-up")
        self.stats = pokemon.getStats()
        self.evolutions = species.getEvolutionChain()
        let types = pokemon.types?.allObjects as? [PokemonType] ?? []
        self.typeDamages = DamageCalculator.calculateMultipliers(forType1: types[0].type!, t2: types.last?.type)
        self.navigationItem.title = self.species.getName(forLocale: "en")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonToAbilitySegue" {
            print("In Segue")
            if let vc = segue.destination as? AbilityViewController, let i = self.tableView.indexPathForSelectedRow {
                print("Segue vc")
                vc.ability = self.abilities[i.row].ability!
            }
        }
    }
}


//// MARK: UITableViewDelegate and UITableViewDataSource methods
extension PokemonViewController {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let s = Sections(rawValue: section) {
            return s.name()
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let s = Sections(rawValue: section) {
            switch s {
            case .info:
                return nil
            case .damageRelations:
                return nil
            case .evolutions:
                return nil
            case .abilities:
                return nil
            case .baseStats:
                return nil
            case .moves:
                return moveSegmentControl
            }
        }
        return nil
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let s = Sections(rawValue: section) {
            switch s {
            case .info:
                return 1
            case .damageRelations:
                return 1
            case .evolutions:
                return 1
            case .abilities:
                return abilities.count
            case .baseStats:
                return 7
            case .moves:
                return moves.count
            }
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let s = Sections(rawValue: indexPath.section) {
            switch s {
            case .info:
                switch indexPath.row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: PokemonSpriteCell.identifier) as! PokemonSpriteCell
                    cell.setup(forPokemon: self.pokemon)
                    return cell
                default:
                    return UITableViewCell()
                }
            case .damageRelations:
                let cell = tableView.dequeueReusableCell(withIdentifier: "DamageRelationsCollectionCell" ) as! CollectionCell
                cell.collectionView.tag = CollectionViews.damageRelations.rawValue
                cell.setup(withDelegate: self, dataSource: self)
                return cell
            case .evolutions:
                let cell = tableView.dequeueReusableCell(withIdentifier: CollectionCell.identifier) as! CollectionCell
                cell.collectionView.tag = CollectionViews.evolutions.rawValue
                cell.setup(withDelegate: self, dataSource: self)
                return cell
            case .abilities:
                let cell = tableView.dequeueReusableCell(withIdentifier: AbilityCell.identifier) as! AbilityCell
                cell.setup(withAbility: self.abilities[indexPath.row])
                return cell
            case .baseStats:
                let cell = tableView.dequeueReusableCell(withIdentifier: StatCell.identifier) as! StatCell
                switch indexPath.row {
                case 0:
                    let stat = self.stats.first { $0.stat?.name == "hp" }!
                    cell.setup(forStat: stat)
                case 1:
                    let stat = self.stats.first { $0.stat?.name == "attack" }!
                    cell.setup(forStat: stat)
                case 2:
                    let stat = self.stats.first { $0.stat?.name == "defense" }!
                    cell.setup(forStat: stat)
                case 3:
                    let stat = self.stats.first { $0.stat?.name == "special-attack" }!
                    cell.setup(forStat: stat)
                case 4:
                    let stat = self.stats.first { $0.stat?.name == "special-defense" }!
                    cell.setup(forStat: stat)
                case 5:
                    let stat = self.stats.first { $0.stat?.name == "speed" }!
                    cell.setup(forStat: stat)
                default:
                    cell.setup(forName: "Total", value: Int(self.pokemon.totalBaseStats))
                }
                return cell
            case .moves:
                let cell = tableView.dequeueReusableCell(withIdentifier: MoveCell.identifier) as! MoveCell
                cell.setup(withMove: self.moves[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
}

extension PokemonViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let col = CollectionViews(rawValue: collectionView.tag) {
            switch col {
            case .forms:
                return varieties.count
            case .damageRelations:
                return Typing.allCases.count
            case .evolutions:
                return evolutions.count
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let col = CollectionViews(rawValue: collectionView.tag) {
            switch col {
            case .forms:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormCollectionCell.identifier, for: indexPath) as! FormCollectionCell
                cell.setup(withVariety: self.varieties[indexPath.row])
                return cell
            case .damageRelations:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TypeCollectionCell.identifier, for: indexPath) as! TypeCollectionCell
                let type = orderedTypes[indexPath.row]
                let dmg = self.typeDamages[type.rawValue] ?? 1.0
                cell.setup(withType: type, damage: dmg)
                return cell
            case .evolutions:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormCollectionCell.identifier, for: indexPath) as! FormCollectionCell
                cell.setup(withSpecies: evolutions[indexPath.row].species)
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    
}
