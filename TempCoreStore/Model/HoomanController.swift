//
//  HoomanController.swift
//  TempCoreStore
//
//  Created by K Y on 9/24/19.
//  Copyright © 2019 K Y. All rights reserved.
//

protocol HoomanController {
    var tempHoomans: [Hooman] { get }
    var savedHoomans: [Hooman] { get }
    func addHooman(_ name: String)
    func saveHooman(_ hooman: Hooman)
    func deleteHooman(_ hooman: Hooman)
}

