//
//  CoreDataManager.swift
//  TempCoreStore
//
//  Created by K Y on 9/24/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import CoreData


final class CoreDataManager {
        
    // MARK: - Core Data stack
    
    lazy var tempContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentContainer.persistentStoreCoordinator
        return context
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentContainer.persistentStoreCoordinator
        return context
    }()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TempCoreStore")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
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
    
    @discardableResult
    func deleteAllEntities(_ description: String) -> String {
        let entities = loadEntities(description)
        for entity in entities {
            mainContext.delete(entity)
        }
        saveContext()
        return "Did delete \(entities.count) \(description)'s from persistent storage!"
    }
    
    func saveEntity(_ entity: NSManagedObject) {
        mainContext.insert(entity)
        saveContext()
    }
    
    func deleteEntity(_ entity: NSManagedObject) {
        mainContext.delete(entity)
        saveContext()
    }
    
    @discardableResult
    func makeEntity(with name: String) -> NSManagedObject? {
        guard let desc = NSEntityDescription.entity(forEntityName: "Hooman", in: tempContext) else {
            return nil
        }
        let object = NSManagedObject(entity: desc, insertInto: nil)
        object.setValue(name, forKey: "name")
        return object
    }
    
}


