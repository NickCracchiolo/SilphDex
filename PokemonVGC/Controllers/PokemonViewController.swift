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
    
    var coreDataManager:CoreDataManager!
    var species:PokemonSpecies!
    var pokemon:Pokemon?
    var varieties:[PokemonSpeciesVariety] = []
    var abilities:[PokemonAbility] = []
    var moves:[PokemonMove] = []
    var stats:[PokemonStat] = []
    var evolutions:[ChainLink] = []
    var typeDamages:[String:Float] = [:]
    let orderedTypes = Typing.allCasesOrdered
    var team:Team?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        self.navigationItem.title = self.species.getName(forLocale: "en")
        self.navigationItem.largeTitleDisplayMode = .automatic
        addNavigationButtons()
        speciesSetup()
        pokemonSetup()
    }
    
    private func speciesSetup() {
        self.varieties = species.getVarieties()
        self.evolutions = species.getEvolutionChain()
    }
    
    private func pokemonSetup() {
        if pokemon == nil {
            self.pokemon = species.getDefaultVariety()
        }
        self.abilities = pokemon?.getAbilities() ?? []
        if let p = pokemon {
            self.moves = self.coreDataManager.getMoves(forPokemonID: p.id, method: MLM.levelUp)
        }
        self.moves.sort { (m1, m2) -> Bool in
            let vg = UserDefaults.standard.integer(forKey: Defaults.versionGroup)
            guard let v1 = (m1.versionGroupDetails?.allObjects as? [PokemonMoveVersion] ?? []).first(where: {($0.versionGroup?.id ?? 0) == vg}) else {
                return false
            }
            guard let v2 = (m2.versionGroupDetails?.allObjects as? [PokemonMoveVersion] ?? []).first(where: {($0.versionGroup?.id ?? 0) == vg}) else {
                return true
            }
            return v1.levelLearnedAt <= v2.levelLearnedAt
        }
        self.stats = pokemon?.getStats() ?? []
        let types = pokemon?.types?.allObjects as? [PokemonType] ?? []
        self.typeDamages = DamageCalculator.calculateMultipliers(forType1: types[0].type!, t2: types.last?.type)
    }
    
    private func registerCells() {
        self.tableView.register(UINib(nibName: PokemonSpriteCell.identifier, bundle: nil), forCellReuseIdentifier: PokemonSpriteCell.identifier)
        self.tableView.register(UINib(nibName: CollectionCell.identifier, bundle: nil), forCellReuseIdentifier: CollectionCell.identifier)
        self.tableView.register(UINib(nibName: AbilityCell.identifier, bundle: nil), forCellReuseIdentifier: AbilityCell.identifier)
        self.tableView.register(UINib(nibName: StatCell.identifier, bundle: nil), forCellReuseIdentifier: StatCell.identifier)
        self.tableView.register(UINib(nibName: MoveCell.identifier, bundle: nil), forCellReuseIdentifier: MoveCell.identifier)
    }
    
    private func addNavigationButtons() {
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add(_:)))
        let formBtn = UIBarButtonItem(title: "Forms", style: .plain, target: self, action: #selector(changeForm(_:)))
        self.navigationItem.rightBarButtonItems = [addBtn, formBtn]
    }
    
    @objc func add(_ sender:UIBarButtonItem) {
        if let t = self.team {
            print("Adding to current team")
            let p = TeamPokemon(context: self.coreDataManager.persistentContainer.viewContext)
            p.pokemon = self.pokemon
            p.name = self.pokemon?.name?.capitalize(letter: 1)
            p.level = 50
            p.nature = self.coreDataManager.getNatures().first
            for iv in self.coreDataManager.allIVs(withValue: 31) {
                p.addToIvs(iv)
            }
            for ev in self.coreDataManager.allEVs(withValue: 0) {
                p.addToEvs(ev)
            }
            t.addToPokemon(p)
            self.coreDataManager.saveContext()
            if let vc = self.navigationController?.viewControllers.first(where: {$0 is TeamViewController}) {
                self.navigationController?.popToViewController(vc, animated: true)
            } else {
                self.navigationController?.popToRootViewController(animated: true)
            }
        } else {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let addToTeam = UIAlertAction(title: "Add to Team", style: .default) { [weak self] (action) in
                guard let self = self else { return }
                let vc = AddTeamViewController()
                vc.coreDataManager = self.coreDataManager
                vc.addingPokemon = self.pokemon
                self.navigationController?.pushViewController(vc, animated: true)
            }
            alert.addAction(addToTeam)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
            alert.popoverPresentationController?.barButtonItem = sender
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func moveLearnMethodDidChange(_ sender:UISegmentedControl) {
        switch sender.tag {
        case 1:
            break
        case 2:
            break
        default:
            break
        }
    }
    
    @objc func changeForm(_ sender:UIBarButtonItem) {
        let alert = UIAlertController(title: "Change Form", message: nil, preferredStyle: .actionSheet)
        alert.popoverPresentationController?.barButtonItem = sender
        for v in self.varieties {
            let a = UIAlertAction(title: v.pokemon?.name, style: .default) { [weak self] (action) in
                guard let self = self else { return }
                self.pokemon = v.pokemon
                self.pokemonSetup()
                self.tableView.reloadData()
            }
            alert.addAction(a)
        }
        self.present(alert, animated: true, completion: nil)
    }
}


//// MARK: UITableViewDelegate and UITableViewDataSource methods
extension PokemonViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let s = Sections(rawValue: indexPath.section) {
            switch s {
            case .info:
                return self.tableView.estimatedRowHeight
            case .damageRelations:
                return 60
            case .evolutions:
                return 105
            case .abilities:
                return self.tableView.estimatedRowHeight
            case .baseStats:
                return self.tableView.estimatedRowHeight
            case .moves:
                return 72
            }
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let s = Sections(rawValue: indexPath.section) {
            switch s {
            case .abilities:
                let vc = AbilityViewController()
                vc.ability = self.abilities[indexPath.row].ability!
                vc.coreDataManager = self.coreDataManager
                self.navigationController?.pushViewController(vc, animated: true)
            case .moves:
                let vc = MoveViewController()
                vc.move = self.moves[indexPath.row].move!
                vc.coreDataManager = self.coreDataManager
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let s = Sections(rawValue: section) {
            return s.name()
        }
        return nil
    }
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if let s = Sections(rawValue: section) {
//            switch s {
//            case .moves:
//                return 60
//            default:
//                return 0
//            }
//        }
//        return 0
//    }
    /*
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
                let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 60))
                view.backgroundColor = UIColor.white
                let seg1 = UISegmentedControl(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 30))
                var i = 0
                let cases = MLM.allCases
                while i <= (cases.count / 2) {
                    seg1.insertSegment(withTitle: cases[i].displayName(), at: i, animated: false)
                    i += 1
                }
                seg1.tag = 1
                seg1.selectedSegmentIndex = 0
                seg1.addTarget(self, action: #selector(moveLearnMethodDidChange(_:)), for: .valueChanged)
                let seg2 = UISegmentedControl(frame: CGRect(x: 0, y: 30, width: self.view.bounds.width, height: 30))
                while i < cases.count {
                    seg2.insertSegment(withTitle: cases[i].displayName(), at: i, animated: false)
                    i += 1
                }
                seg2.tag = 2
                seg2.addTarget(self, action: #selector(moveLearnMethodDidChange(_:)), for: .valueChanged)
                view.addSubview(seg1)
                view.addSubview(seg2)
                return view
            }
        }
        return nil
    } */
    
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
                    if let p = self.pokemon {
                        let cell = tableView.dequeueReusableCell(withIdentifier: PokemonSpriteCell.identifier) as! PokemonSpriteCell
                        cell.setup(forPokemon: p)
                        return cell
                    }
                    return UITableViewCell()
                default:
                    return UITableViewCell()
                }
            case .damageRelations:
                let cell = tableView.dequeueReusableCell(withIdentifier: CollectionCell.identifier) as! CollectionCell
                cell.setup(withDelegate: self, dataSource: self, tag: CollectionViews.damageRelations.rawValue, cellId: TypeCollectionCell.identifier)
                return cell
            case .evolutions:
                let cell = tableView.dequeueReusableCell(withIdentifier: CollectionCell.identifier) as! CollectionCell
                cell.setup(withDelegate: self, dataSource: self, tag: CollectionViews.evolutions.rawValue, cellId: FormCollectionCell.identifier)
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
                    cell.setup(forName: "Total", value: Int(self.pokemon?.totalBaseStats ?? 0))
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

extension PokemonViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let col = CollectionViews(rawValue: collectionView.tag) {
            switch col {
            case .forms:
                let vc = PokemonViewController()
                let v = self.varieties[indexPath.row]
                vc.coreDataManager = self.coreDataManager
                vc.pokemon = v.pokemon!
                vc.species = v.species!
                vc.coreDataManager = self.coreDataManager
                self.navigationController?.pushViewController(vc, animated: true)
            case .damageRelations:
                return
            case .evolutions:
                let vc = PokemonViewController()
                vc.coreDataManager = self.coreDataManager
                vc.species = self.evolutions[indexPath.row].species!
                vc.coreDataManager = self.coreDataManager
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let col = CollectionViews(rawValue: collectionView.tag) {
            switch col {
            case .forms:
                return CGSize(width: 87, height: 105)
            case .damageRelations:
                return CGSize(width: 86, height: 60)
            case .evolutions:
                return CGSize(width: 87, height: 105)
            }
        }
        return CGSize.zero
    }
}
