//
//  HoomanModelController.swift
//  TempCoreStore
//
//  Created by K Y on 9/24/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import Foundation

protocol HoomanController {
    var tempHoomans: [Hooman] { get }
    var savedHoomans: [Hooman] { get }
    func addHooman(_ name: String)
    func saveHooman(_ hooman: Hooman)
    func deleteHooman(_ hooman: Hooman)
}


class HoomanModelController: HoomanController {
    
    var tempHoomans: [Hooman] = [Hooman]()
    var savedHoomans: [Hooman] = [Hooman]()
    
    let coreData: CoreDataManager = CoreDataManager()
    
    init() {
        // load hoomans
        savedHoomans = coreData.loadEntities("Hooman") as! [Hooman]
        print("There are \(savedHoomans.count) hoomans saved!")
        // let deleteStr = coreData.deleteAllEntities("Hooman")
        // print(deleteStr)
    }
    
    func saveHooman(_ hooman: Hooman) {
        if tempHoomans.contains(hooman) {
            tempHoomans.removeAll(where: { $0 === hooman })
            savedHoomans.append(hooman)
            coreData.saveEntity(hooman)
        }
        
    }
    func deleteHooman(_ hooman: Hooman) {
        if savedHoomans.contains(hooman) {
            savedHoomans.removeAll(where: { $0 === hooman })
            coreData.deleteEntity(hooman)
        }
    }
    
    
    func addHooman(_ name: String) {
        let newHooman = coreData.makeEntity(with: name)
        tempHoomans.append(newHooman as! Hooman)
    }
    
}
