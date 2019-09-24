//
//  CoreDataManager.swift
//  TempCoreStore
//
//  Created by K Y on 9/24/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import CoreData

/*
 Core Data Manager with two contexts:
 
 tempContext - a temporary context that does not persist to disk
 mainContext - a context that persists items to disk
 
 Normal data creation lifecycle is as such, managed by calling
 instance methods on this class:
 
 * make in temp -> save to main -> delete from temp
 
 * load from disk to main -> use in main
 
 * delete from main -> delete from disk
 
 */
final class CoreDataManager {
        
    // MARK: - Core Data stack
    
    /// temporary context, items are made temporary here
    /// is not backed into persistent store
    lazy private var tempContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentContainer.persistentStoreCoordinator
        return context
    }()
    
    /// main context, items made here are backed into persistent store upon saving.
    lazy private var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentContainer.persistentStoreCoordinator
        return context
    }()

    /// persistent container object, >iOS 10
    lazy private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TempCoreStore")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    /// save context, back to disk
    private func saveContext () {
        let context = mainContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    /// load all entities of name provided
    func loadEntities(_ description: String) -> [NSManagedObject] {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: description)
        let results: [NSManagedObject]
        do {
            results = try mainContext.fetch(fetch) as! [NSManagedObject]
        }
        catch {
            print(error)
            results = []
        }

        return results
    }
    
    /// delete all entities of name provided,
    /// Return: string describing number of items of name deleted
    @discardableResult
    func deleteAllEntities(_ description: String) -> String {
        let entities = loadEntities(description)
        for entity in entities {
            mainContext.delete(entity)
        }
        saveContext()
        return "Did delete \(entities.count) \(description)'s from persistent storage!"
    }
    
    /// call this to pivot an item from the tempContext to the mainContext
    func saveEntity(_ entity: NSManagedObject) {
        if entity.managedObjectContext === tempContext {
            mainContext.insert(entity)
            tempContext.delete(entity)
            saveContext()
        }
    }
    
    /// call this to delete an item currently in the mainContext
    func deleteEntity(_ entity: NSManagedObject) {
        if entity.managedObjectContext === mainContext {
            mainContext.delete(entity)
            saveContext()
        }
    }
    
    /// call this to create an entity of entityName and populate its contents with a dictionary of items
    @discardableResult
    func makeEntity(with entityName: String, info: [String:Any]) -> NSManagedObject? {
        guard let desc = NSEntityDescription.entity(forEntityName: entityName,
                                                    in: tempContext) else {
            return nil
        }
        let object = NSManagedObject(entity: desc, insertInto: nil)
        for key in info.keys {
            object.setValue(info[key], forKey: key)
        }
        return object
    }
    
}


