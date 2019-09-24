//
//  Hooman+CoreDataProperties.swift
//  TempCoreStore
//
//  Created by K Y on 9/24/19.
//  Copyright © 2019 K Y. All rights reserved.
//
//

import Foundation
import CoreData


extension Hooman {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Hooman> {
        return NSFetchRequest<Hooman>(entityName: "Hooman")
    }

    @NSManaged public var name: String?

}
