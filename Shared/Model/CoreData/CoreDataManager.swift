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
    
    class func preloadDBData() {
        let sqlitePath = Bundle.main.path(forResource: "Pokedex", ofType: "sqlite")
        let sqlitePath_shm = Bundle.main.path(forResource: "Pokedex", ofType: "sqlite-shm")
        let sqlitePath_wal = Bundle.main.path(forResource: "Pokedex", ofType: "sqlite-wal")
        
        let URL1 = URL(fileURLWithPath: sqlitePath!)
        let URL2 = URL(fileURLWithPath: sqlitePath_shm!)
        let URL3 = URL(fileURLWithPath: sqlitePath_wal!)
        let URL4 = URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/Pokedex.sqlite")
        let URL5 = URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/Pokedex.sqlite-shm")
        let URL6 = URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/Pokedex.sqlite-wal")
        
        if !FileManager.default.fileExists(atPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/Pokedex.sqlite") {
            do {
                try FileManager.default.copyItem(at: URL1, to: URL4)
                try FileManager.default.copyItem(at: URL2, to: URL5)
                try FileManager.default.copyItem(at: URL3, to: URL6)
                
            } catch {
                print("ERROR IN COPY OPERATION")
            }
        } else {
            print("FILES EXIST")
        }
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
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: name)
        do {
            let results = try self.persistentContainer.viewContext.fetch(fetchRequest)
            return results
        } catch {
            print("NSManagedObject Array Fetch Request Failed with error: \(error.localizedDescription)")
            return []
        }
    }
    
    func getPokedexNames() -> [String] {
        let fetchRequest = NSFetchRequest<Pokedex>(entityName: Entity.pokedex)
        let vg = UserDefaults.standard.integer(forKey: "VersionGroup")
        let predicate = NSPredicate(format: "SUBQUERY(versionGroups, $x, $x.id == %d).@count > 0", vg)
        fetchRequest.predicate = predicate
        do {
            let results = try self.persistentContainer.viewContext.fetch(fetchRequest)
            let dexes = results
            var names:[String] = []
            for d in dexes {
                if let n = d.name {
                    names.append(n.capitalize(letter: 1))
                }
            }
            return names
        } catch {
            return []
        }
    }
    
    func getMoves(forPokemonID id:Int16, method:MLM) -> [PokemonMove] {
        let vg = UserDefaults.standard.integer(forKey: Defaults.versionGroup)
        let fetchRequest = NSFetchRequest<PokemonMove>(entityName: Entity.pokemonMove)
        let predicate = NSPredicate(format: "pokemon.id == %d AND SUBQUERY(versionGroupDetails, $x, $x.moveLearnMethod.id == %d AND $x.versionGroup.id == %d).@count > 0", id, method.rawValue, vg)
        fetchRequest.predicate = predicate
        do {
            let results = try self.persistentContainer.viewContext.fetch(fetchRequest)
            return results
        } catch {
            print("NSManagedObject Array Fetch Request Failed with error: \(error.localizedDescription)")
            return []
        }
    }
    
    func getNatures() -> [Nature] {
        let fetchRequest = NSFetchRequest<Nature>(entityName: Entity.nature)
        let sorts = [NSSortDescriptor(key: "name", ascending: true)]
        fetchRequest.sortDescriptors = sorts
        do {
            let results = try self.persistentContainer.viewContext.fetch(fetchRequest)
            return results
        } catch {
            print("Nature Array Fetch Request Failed with error: \(error.localizedDescription)")
            return []
        }
    }
    
    func getTeams() -> [Team] {
        let fetchRequest = NSFetchRequest<Team>(entityName: Entity.team)
        let vg = UserDefaults.standard.integer(forKey: "VersionGroup")
        let predicate = NSPredicate(format: "versionGroup.id == %d", vg)
        fetchRequest.predicate = predicate
        do {
            let results = try self.persistentContainer.viewContext.fetch(fetchRequest)
            return results
        } catch {
            print("Nature Array Fetch Request Failed with error: \(error.localizedDescription)")
            return []
        }
    }
    
    func getStat(forName name:String) -> Stat? {
        let fetchRequest = NSFetchRequest<Stat>(entityName: Entity.stat)
        
        do {
            let results = try self.persistentContainer.viewContext.fetch(fetchRequest)
            return results.first(where: { $0.name == name.lowercased() })
        } catch {
            print("Stat for name Fetch Request Failed with error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getStats(isBattleOnly battle:Bool) -> [Stat] {
        let fetchRequest = NSFetchRequest<Stat>(entityName: Entity.stat)
        let predicate = NSPredicate(format: "isBattleOnly == %@", NSNumber(booleanLiteral: battle))
        fetchRequest.predicate = predicate
        let sorts = [NSSortDescriptor(key: "id", ascending: true)]
        fetchRequest.sortDescriptors = sorts
        do {
            let results = try self.persistentContainer.viewContext.fetch(fetchRequest)
            return results
        } catch {
            print("Stat Array Fetch Request Failed with error: \(error.localizedDescription)")
            return []
        }
    }
    
    func getMoveLearnMethods() -> [MoveLearnMethod] {
        let fetchRequest = NSFetchRequest<MoveLearnMethod>(entityName: Entity.moveLearnMethod)
        let sorts = [NSSortDescriptor(key: "id", ascending: true)]
        fetchRequest.sortDescriptors = sorts
        do {
            let results = try self.persistentContainer.viewContext.fetch(fetchRequest)
            return results
        } catch {
            print("MoveLearnMethod Array Fetch Request Failed with error: \(error.localizedDescription)")
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
    class func pokedexPredicate(forPokedex pkdex:String) -> NSPredicate {
        return NSPredicate(format: "pokedex.name == %@", pkdex)
    }
    
    func allIVs(withValue val:Int16) -> [PokemonIV] {
        var arr:[PokemonIV] = []
        let statNames = ["hp", "attack", "defense", "special-attack", "special-defense", "speed"]
        for name in statNames {
            let iv = PokemonIV(context: self.persistentContainer.viewContext)
            iv.stat = getStat(forName: name)
            iv.value = val
            arr.append(iv)
        }
        return arr
    }
    
    func allEVs(withValue val:Int16) -> [PokemonEV] {
        var arr:[PokemonEV] = []
        let statNames = ["hp", "attack", "defense", "special-attack", "special-defense", "speed"]
        for name in statNames {
            let ev = PokemonEV(context: self.persistentContainer.viewContext)
            ev.stat = getStat(forName: name)
            ev.value = val
            arr.append(ev)
        }
        return arr
    }
}
