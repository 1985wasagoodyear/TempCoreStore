//
//  HoomanModelController.swift
//  TempCoreStore
//
//  Created by K Y on 9/24/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import Foundation

class HoomanModelController: HoomanController {
    
    /// temporary items
    var tempHoomans: [Hooman] = [Hooman]()
    
    /// actually persisted items
    var savedHoomans: [Hooman] = [Hooman]()
    
    /// Core Data Manager object
    private let coreData: CoreDataManager = CoreDataManager()
    
    /// init - loads saved items on creation
    init() {
        savedHoomans = coreData.loadEntities("Hooman") as! [Hooman]
        print("There are \(savedHoomans.count) hoomans saved!")
    }
    
    /// saves a hooman
    /// Parameters:
    ///     * hooman - a hooman in the current temp list
    func saveHooman(_ hooman: Hooman) {
        if tempHoomans.contains(hooman) {
            tempHoomans.removeAll(where: { $0 === hooman })
            let savedEntity = coreData.saveEntity(hooman)
            savedHoomans.append(savedEntity! as! Hooman)
        }
    }
    
    /// deletes a persisted hooman
    /// Parameters:
    ///     * hooman - a hooman in the current saved items list
    func deleteHooman(_ hooman: Hooman) {
        if savedHoomans.contains(hooman) {
            savedHoomans.removeAll(where: { $0 === hooman })
            let tempEntity = coreData.deleteEntity(hooman)
            tempHoomans.append(tempEntity! as! Hooman)
        }
    }
    
    /// creates a new hooman
    /// this app only has a name for each hooman
    func addHooman(_ name: String) {
        let newHooman = coreData.makeEntity(with: "Hooman",
                                            info: ["name" : name])
        tempHoomans.append(newHooman as! Hooman)
    }
    
}
