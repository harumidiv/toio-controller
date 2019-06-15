//
//  ToioPeripheral.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/15.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import CoreBluetooth
import RxBluetoothKit
import RxSwift
import UIKit

protocol ToioPeripheral {
    associatedtype ServiceType: ToioPeripheralService
    init(peripheral: Peripheral)
    var peripheral: Peripheral! { get }
}

extension ToioPeripheral {
    static var serviceTypes: [Self.ServiceType] {
        return ServiceType.allCases as! [Self.ServiceType]
    }

    func discoveryServices(types: [ServiceType]) -> Observable<[Service]> {
        let uuids = types.map { type -> CBUUID in
            CBUUID(string: type.uuid)
        }
        return peripheral.discoverServices(uuids).asObservable()
    }

    func discoveryService(type: ServiceType) -> Observable<Service> {
        return discoveryServices(types: [type]).flatMap {
            Observable.from(optional: $0[safe: 0])
        }
    }

    func discoveryCharacteristics(types: [ServiceType.CharacteristicType], service: Service) -> Observable<[Characteristic]> {
        let uuids = types.map { type -> CBUUID in
            CBUUID(string: type.uuid)
        }
        return peripheral.discoverCharacteristics(uuids, for: service).asObservable()
    }

    func discoveryCharacterstic(type: ServiceType.CharacteristicType, service: Service) -> Observable<Characteristic> {
        return discoveryCharacteristics(types: [type], service: service).flatMap {
            Observable.from(optional: $0[safe: 0])
        }
    }
}

// MARK: - ToioPeripheralService

protocol ToioPeripheralService: CaseIterable {
    associatedtype CharacteristicType: ToioPeripheralCharacteristic
    var uuid: String { get }
}

// MARK: - ToioPeripheralCharacteristic

protocol ToioPeripheralCharacteristic {
    var uuid: String { get }
}
