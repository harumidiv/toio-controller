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

    func writeValue(characteristic: CubeCharacteristic, data: Data, type: CBCharacteristicWriteType) -> Observable<Void> {
        return Observable<Void>.create { [weak self] observe -> Disposable in
            guard let self = self else {
                return Disposables.create()
            }
            self.getCharacteristic(type: characteristic)
                .subscribe(onNext: { [weak self] c in
                    guard let self = self else {
                        return
                    }
                    c.writeValue(data, type: type).subscribe { e in
                        switch e {
                        case .success:
                            observe.onNext(())
                            observe.onCompleted()
                        case let .error(e):
                            observe.onError(e)
                        }
                    }.disposed(by: self.disposeBag)
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }

    private func getCharacteristic(type: CubeCharacteristic) -> Observable<Characteristic> {
        let innerGetCharacteristic = { (type: CubeCharacteristic, service: Service) -> Observable<Characteristic> in
            self.discoveryCharacterstic(type: type, service: service).asObservable().flatMap { value -> Observable<Characteristic> in
                Observable.of(value)
            }
        }
        return getService(type: .toioTrolley).flatMap { service -> Observable<Characteristic> in
            innerGetCharacteristic(type, service)
        }
    }

    private func getService(type: CubeService) -> Observable<Service> {
        return discoveryService(type: type).asObservable().flatMap { value -> Observable<Service> in
            Observable.of(value)
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
    case sound = "10B20104-5B3B-4571-9508-CF3EFCD7BBAE"
    case battery = "10B20108-5B3B-4571-9508-CF3EFCD7BBAE"
    case moter = "10B20102-5B3B-4571-9508-CF3EFCD7BBAE"

    var uuid: String {
        return rawValue
    }
}
