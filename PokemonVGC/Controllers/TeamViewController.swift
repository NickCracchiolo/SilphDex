//
//  TeamViewController.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 9/21/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

class TeamViewController: UICollectionViewController {
    var coreDataManager:CoreDataManager!
    var team:Team?
    var pokemon:[TeamPokemon?] = Array(repeating: nil, count: 6)
    let cellInterspacing:CGFloat = 16.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        registerCells()
        self.navigationItem.title = team?.name
        //addNameField()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTeamPokemon()
        self.collectionView.reloadData()
    }
    
    private func registerCells() {
        self.collectionView.register(UINib(nibName: FormCollectionCell.identifier, bundle: nil), forCellWithReuseIdentifier: FormCollectionCell.identifier)
    }
    
    private func setupCollectionView() {
        self.collectionView.backgroundColor = .white
    }
    
    private func addNameField() {
        let rect = self.navigationController?.navigationBar.bounds ?? CGRect(x: 0, y: 0, width: 100, height: 21)
        let field = UITextField(frame: rect)
        field.addTarget(self, action: #selector(updateName(_:)), for: .editingChanged)
        self.navigationController?.navigationBar.addSubview(field)
    }
    
    private func setupTeamPokemon() {
        var i = 0
        for p in team?.getPokemon() ?? [] {
            pokemon[i] = p
            i += 1
        }
    }
    
    @objc func updateName(_ sender:UITextField) {
        
    }
    
}

extension TeamViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow:CGFloat = 2
        let spacingBetweenCells:CGFloat = 16
        
        let totalSpacing = (1.0 * cellInterspacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        
        let width = (self.collectionView.bounds.width - totalSpacing)/numberOfItemsPerRow
        switch indexPath.section {
        case 0:
            return CGSize(width: width, height: width)
        default:
            return CGSize.zero
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let p = pokemon[indexPath.row] {
            // segue to pokemon view
            print("Load saved pokemon")
        } else {
            // segue to add a new pokemon
            print("Create new pokemon")
            let vc = PokedexiOSViewController()
            vc.dataModel = PokedexDataModel(withCoreDataManager: self.coreDataManager)
            vc.adding = true
            vc.team = self.team
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemon.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormCollectionCell.identifier, for: indexPath) as! FormCollectionCell
        if let p = pokemon[indexPath.row] {
            cell.nameLabel.text = p.name?.capitalize(letter: 1)
            if let front = p.pokemon!.sprites?.frontDefault {
                cell.spriteView.image = UIImage(data: front)
            }
        } else {
            cell.nameLabel.text = "Add Pokemon"
            cell.spriteView.image = UIImage(named: "Add")
        }
        return cell
    }
}
