//
//  ViewController.swift
//  PokemonVGC_macOS
//
//  Created by Nick Cracchiolo on 8/29/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import Cocoa

class PokedexViewController: NSViewController, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var tableView: NSTableView!
    
    let coreDataManager = CoreDataManager(withModelName: "Pokedex")
    var entityName:String = Entity.pokemon
    
    var sortKey:String? = "order"
    
    var ascending:Bool = true
    
    var predicate:NSPredicate?
    
    private var request:NSFetchRequest<Pokemon> {
        get {
            let fetchRequest = NSFetchRequest<Pokemon>(entityName: entityName)
            if let p = self.predicate {
                fetchRequest.predicate = p
            }
            
            // Add Sort Descriptors
            if let key = sortKey {
                let sortDescriptor = NSSortDescriptor(key: key, ascending: self.ascending)
                fetchRequest.sortDescriptors = [sortDescriptor]
            }
            return fetchRequest
        }
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<Pokemon> = {
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: self.request, managedObjectContext: self.coreDataManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        setDescriptors()
        do {
            try fetchedResultsController.performFetch()
            self.tableView.reloadData()
        } catch {
            print("Error fetching: \(error.localizedDescription)")
        }
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func setDescriptors() {
        let order = NSSortDescriptor(key: "order", ascending: true)
        let name = NSSortDescriptor(key: "name", ascending: true)
        let stat = NSSortDescriptor(key: "totalBaseStats", ascending: true)
        //let statValue = NSSortDescriptor(key: "stats.baseStat", ascending: true)
        self.tableView.tableColumns[0].sortDescriptorPrototype = order
        self.tableView.tableColumns[1].sortDescriptorPrototype = name
        self.tableView.tableColumns[3].sortDescriptorPrototype = stat
    }
}

extension PokedexViewController: NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        print("Sort Descriptors Changed")
        
    }
    
    func tableView(_ tableView: NSTableView, didClick tableColumn: NSTableColumn) {
        print("Clicked")
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let pokemon = fetchedResultsController.object(at: IndexPath(item: row, section: 0))
        let stats = pokemon.stats?.allObjects as? [PokemonStat] ?? []
        var text:String = ""
        var image:NSImage?
        var id:NSUserInterfaceItemIdentifier = NSUserInterfaceItemIdentifier.init("pokemonNameCell")
        
        if tableColumn == tableView.tableColumns[0] {
            text = "\(pokemon.order)"
            image = nil
            id = NSUserInterfaceItemIdentifier.init("pokemonLabelCell")
        } else if tableColumn == tableView.tableColumns[1] {
            text = pokemon.name!
            if let front = pokemon.sprites?.frontDefault {
                image = NSImage(data: front)
            }
            id = NSUserInterfaceItemIdentifier.init("pokemonNameCell")
        } else if tableColumn == tableView.tableColumns[2] {
            for t in pokemon.types?.allObjects as? [PokemonType] ?? [] {
                text += "\(t.type!.name!) "
            }
            if let front = pokemon.sprites?.frontDefault {
                image = NSImage(data: front)
            }
            id = NSUserInterfaceItemIdentifier.init("pokemonTypeCell")
        } else if tableColumn == tableView.tableColumns[3] {
            text = "\(pokemon.totalBaseStats)"
            image = nil
            id = NSUserInterfaceItemIdentifier.init("pokemonStatCell")
        } else if tableColumn == tableView.tableColumns[4] {
            if let first = stats.first(where: { $0.stat?.name == "hp" }) {
                text = "\(first.baseStat)"
            } else {
                text = "0"
            }
            id = NSUserInterfaceItemIdentifier.init("pokemonStatCell")
        } else if tableColumn == tableView.tableColumns[5] {
            if let first = stats.first(where: { $0.stat?.name == "attack" }) {
                text = "\(first.baseStat)"
            } else {
                text = "0"
            }
            id = NSUserInterfaceItemIdentifier.init("pokemonStatCell")
        } else if tableColumn == tableView.tableColumns[6] {
            if let first = stats.first(where: { $0.stat?.name == "defense" }) {
                text = "\(first.baseStat)"
            } else {
                text = "0"
            }
            id = NSUserInterfaceItemIdentifier.init("pokemonStatCell")
        } else if tableColumn == tableView.tableColumns[7] {
            if let first = stats.first(where: { $0.stat?.name == "special-attack" }) {
                text = "\(first.baseStat)"
            } else {
                text = "0"
            }
            id = NSUserInterfaceItemIdentifier.init("pokemonStatCell")
        } else if tableColumn == tableView.tableColumns[8] {
            if let first = stats.first(where: { $0.stat?.name == "special-defense" }) {
                text = "\(first.baseStat)"
            } else {
                text = "0"
            }
            id = NSUserInterfaceItemIdentifier.init("pokemonStatCell")
        } else if tableColumn == tableView.tableColumns[9] {
            if let first = stats.first(where: { $0.stat?.name == "speed" }) {
                text = "\(first.baseStat)"
            } else {
                text = "0"
            }
            id = NSUserInterfaceItemIdentifier.init("pokemonStatCell")
        }
        
        if let cell = tableView.makeView(withIdentifier: id, owner: nil) as? NSTableCellView {
            cell.imageView?.image = image
            cell.textField?.stringValue = text
            return cell
        }
        print("nil")
        return nil
    }
}
