//
//  NaturesViewController.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 10/12/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

class NaturesViewController: UITableViewController {
    var coreDataManager:CoreDataManager!
    lazy var natures = self.coreDataManager.getNatures()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func registerCells() {
        self.tableView.register(UINib(nibName: NatureCell.identifier, bundle: nil), forCellReuseIdentifier: NatureCell.identifier)
    }
}

extension NaturesViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return natures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NatureCell.identifier) as! NatureCell
        return cell
    }
}
