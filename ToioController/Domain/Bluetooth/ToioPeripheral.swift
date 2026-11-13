//
//  ToioPeripheral.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/15.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import CoreBluetooth

protocol ToioPeripheral {
    associatedtype ServiceType: ToioPeripheralService
    init(peripheral: CBPeripheral)
    var peripheral: CBPeripheral { get }
}

extension ToioPeripheral {
    static var serviceTypes: [ServiceType] {
        return Array(ServiceType.allCases)
    }
}

// MARK: - ToioPeripheralService

protocol ToioPeripheralService: CaseIterable {
    associatedtype CharacteristicType: ToioPeripheralCharacteristic
    var uuid: String { get }
}

// MARK: - ToioPeripheralCharacteristic

protocol ToioPeripheralCharacteristic: CaseIterable {
    var uuid: String { get }
}
