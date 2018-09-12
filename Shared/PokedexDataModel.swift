//
//  PokemonVGCDataModel.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 9/5/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import CoreData

protocol PokedexDataDelegate: class {
    func dataWasUpdated()
}

class PokedexDataModel:NSObject, NSFetchedResultsControllerDelegate {
    weak var delegate:PokedexDataDelegate?
    
    let coreDataManager:CoreDataManager
    private var entityName:String = Entity.pokemonSpeciesDexEntry
    
    private var sortKey:String? = "entryNumber"
    
    private var ascending:Bool = true
    
    private var predicate:NSPredicate?
    
    private var request:NSFetchRequest<PokemonSpeciesDexEntry> {
        get {
            let fetchRequest = NSFetchRequest<PokemonSpeciesDexEntry>(entityName: entityName)
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
    
    lazy var fetchedResultsController: NSFetchedResultsController<PokemonSpeciesDexEntry> = {
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: self.request, managedObjectContext: self.coreDataManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    init(withCoreDataManager manager:CoreDataManager) {
        self.coreDataManager = manager
    }
    
    func fetch() {
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
    }
    
    func updateController(ascending:Bool?, key:String? = nil, predicate:NSPredicate? = nil) {
        if let a = ascending {
            self.ascending = a
        }
        self.sortKey = key
        self.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: self.sortKey, ascending: self.ascending)
        self.fetchedResultsController.fetchRequest.sortDescriptors = [sortDescriptor]
        self.fetchedResultsController.fetchRequest.predicate = self.predicate
        
        fetch()
    }
    
    func pokedexNames() -> [String] {
        return self.coreDataManager.getPokedexNames()
    }
}
