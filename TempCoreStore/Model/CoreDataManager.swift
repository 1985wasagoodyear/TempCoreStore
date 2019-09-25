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
    
    /// save context, back to disk and cleans up tempContext's changes
    private func saveContext () {
        if mainContext.hasChanges {
            do {
                try mainContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error saving mainContext:\n\(nserror), \(nserror.userInfo)")
            }
        }
        if tempContext.hasChanges {
            do {
                try tempContext.save()
            }
            catch {
                let nserror = error as NSError
                fatalError("Unresolved error saving tempContext:\n\(nserror), \(nserror.userInfo)")
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
    /// Return: item in context of mainContext
    func saveEntity(_ entity: NSManagedObject) -> NSManagedObject? {
        if entity.managedObjectContext == nil || entity.managedObjectContext === tempContext {
            let newEntity = makeEntity(with: entity.entity.name!,
                                       info: entity.attributeDictionary,
                                       context: mainContext)
            tempContext.delete(entity)
            saveContext()
            return newEntity
        }
        return nil
    }
    
    /// call this to delete an item currently in the mainContext
    /// Return: item in context of tempContext
    func deleteEntity(_ entity: NSManagedObject) -> NSManagedObject? {
        if entity.managedObjectContext === mainContext {
            let newEntity = makeEntity(with: entity.entity.name!,
                                       info: entity.attributeDictionary,
                                       context: tempContext)
            
            mainContext.delete(entity)
            saveContext()
            return newEntity
        }
        return nil
    }
    
    /// call this to create an entity of entityName and populate its contents with a dictionary of items
    @discardableResult
    func makeEntity(with entityName: String,
                    info: [String:Any],
                    context: NSManagedObjectContext? = nil) -> NSManagedObject? {
        guard let desc = NSEntityDescription.entity(forEntityName: entityName,
                                                    in: mainContext) else {
                                                        return nil
        }
        let object = NSManagedObject(entity: desc, insertInto: context)
        for key in info.keys {
            object.setValue(info[key], forKey: key)
        }
        return object
    }
    
}

extension NSManagedObject {
    var attributeDictionary: [String: Any] {
        var info: [String: Any] = [:]
        for attribute in self.entity.attributesByName {
            info[attribute.key] = self.value(forKey: attribute.key)
        }
        return info
    }
}

