//
//  Cube.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/15.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import CoreBluetooth
import RxBluetoothKit
import RxSwift

class Cube: ToioPeripheral {
    private let disposeBag = DisposeBag()
    private var connection: Disposable?

    var peripheral: Peripheral!
    typealias ServiceType = CubeService

    required init(peripheral: Peripheral) {
        self.peripheral = peripheral
    }

    func connect() -> Observable<Cube> {
        return Observable<Cube>.create { [weak self] observer -> Disposable in
            guard let self = self else {
                return Disposables.create()
            }
            self.connection = self.peripheral.establishConnection().subscribe(onNext: { connected in
                self.peripheral = connected
                observer.onNext(self)
            }, onError: { error in
                observer.onError(error)
            })
            return Disposables.create()
        }
    }
}

// MARK: - CubeService

enum CubeService: String, ToioPeripheralService {
    typealias CharacteristicType = CubeCharacteristic

    case toioTrolley = "10B20100-5B3B-4571-9508-CF3EFCD7BBAE"

    var uuid: String {
        return rawValue
    }
}

// MARK: - CubeCharacteristic

enum CubeCharacteristic: String, ToioPeripheralCharacteristic {
    case light = "10B20103-5B3B-4571-9508-CF3EFCD7BBAE"
    case button = "10B20107-5B3B-4571-9508-CF3EFCD7BBAE"
    case battery = "10B20108-5B3B-4571-9508-CF3EFCD7BBAE"

    var uuid: String {
        return rawValue
    }
}
