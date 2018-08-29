//
//  CoreDataManager.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 8/29/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import CoreData

class CoreDataManager {
    let modelName:String
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    init(withModelName name:String) {
        self.modelName = name
    }
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                print("Failed to save to data store: \(nserror.localizedDescription)")
                if let details = nserror.userInfo[NSDetailedErrorsKey] as? [NSError] {
                    for d in details {
                        print("\tDetailed Error: \(d.userInfo)")
                    }
                }
                fatalError("Unresolved error")
            }
        }
    }
    
    func getObjects(withName name:String) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        do {
            let results = try self.persistentContainer.viewContext.fetch(fetchRequest)
            return (results as? [NSManagedObject]) ?? []
        } catch {
            print("NSManagedObject Array Fetch Request Failed with error: \(error.localizedDescription)")
            return []
        }
    }
    
    func getPokedexNames() -> [String] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.pokedex)
        let vg = UserDefaults.standard.integer(forKey: "VersionGroup")
        let predicate = NSPredicate(format: "SUBQUERY(versionGroups, $x, $x.id == %d).@count > 0", vg)
        fetchRequest.predicate = predicate
        do {
            let results = try self.persistentContainer.viewContext.fetch(fetchRequest)
            if let dexes = results as? [Pokedex] {
                var names:[String] = []
                for d in dexes {
                    if let n = d.name {
                        names.append(n.capitalize(letter: 1))
                    }
                }
                return names
            } else {
                return []
            }
        } catch {
            return []
        }
    }
    
    func getMoves(forPokemonID id:Int16, method:String) -> [PokemonMove] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.pokemonMove)
        let predicate = NSPredicate(format: "pokemon.id == %d and SUBQUERY(versionGroupDetails, $x, $x.moveLearnMethod.name == %@).@count > 0", id, method)
        fetchRequest.predicate = predicate
        //let sorts = [NSSortDescriptor(key: "<#T##String?#>", ascending: <#T##Bool#>)]
        do {
            let results = try self.persistentContainer.viewContext.fetch(fetchRequest)
            return (results as? [PokemonMove]) ?? []
        } catch {
            print("NSManagedObject Array Fetch Request Failed with error: \(error.localizedDescription)")
            return []
        }
    }
    
    func getNatures() -> [Nature] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.nature)
        let sorts = [NSSortDescriptor(key: "name", ascending: true)]
        fetchRequest.sortDescriptors = sorts
        do {
            let results = try self.persistentContainer.viewContext.fetch(fetchRequest)
            return (results as? [Nature]) ?? []
        } catch {
            print("Nature Array Fetch Request Failed with error: \(error.localizedDescription)")
            return []
        }
    }
    
    func getTeams() -> [Team] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.team)
        let vg = UserDefaults.standard.integer(forKey: "VersionGroup")
        let predicate = NSPredicate(format: "versionGroup.id == %d", vg)
        fetchRequest.predicate = predicate
        do {
            let results = try self.persistentContainer.viewContext.fetch(fetchRequest)
            return (results as? [Team]) ?? []
        } catch {
            print("Nature Array Fetch Request Failed with error: \(error.localizedDescription)")
            return []
        }
    }
    
    func getStat(forName name:String) -> Stat? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.stat)
        
        do {
            let results = try self.persistentContainer.viewContext.fetch(fetchRequest)
            return (results as? [Stat] ?? []).first(where: { $0.name == name.lowercased() })
        } catch {
            print("Nil Fetch Request Failed with error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getStats(isBattleOnly battle:Bool) -> [Stat] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.stat)
        let predicate = NSPredicate(format: "isBattleOnly == %@", NSNumber(booleanLiteral: battle))
        fetchRequest.predicate = predicate
        let sorts = [NSSortDescriptor(key: "id", ascending: true)]
        fetchRequest.sortDescriptors = sorts
        do {
            let results = try self.persistentContainer.viewContext.fetch(fetchRequest)
            return (results as? [Stat]) ?? []
        } catch {
            print("Stat Array Fetch Request Failed with error: \(error.localizedDescription)")
            return []
        }
    }
    
    /// Predicate to be used with a PokemonMove entity to return a filtered group of moves specific to the move learn method.
    func moveLearnPredicate(forPokemonID id:Int16, method:String) -> NSPredicate {
        //let vg = UserDefaults.standard.integer(forKey: "VersionGroup")
        return NSPredicate(format: "pokemon.id = %d and SUBQUERY(versionGroupDetails, $x, $x.moveLearnMethod.name = '%@').@count > 0", id, method)
    }
    
    //Predicate for Pokemon Entities
    func pokemonVersionGroupPredicate() -> NSPredicate {
        let vg = UserDefaults.standard.integer(forKey: "VersionGroup")
        return NSPredicate(format: "SUBQUERY(pokedex.versionGroups, $x, $x.id = %d).@count > 0", vg)
    }
    
    //Used to fetch PokedexEntry
    func pokedexPredicate(forPokedex pkdex:String) -> NSPredicate {
        return NSPredicate(format: "pokedex.name == %@", pkdex)
    }
}
