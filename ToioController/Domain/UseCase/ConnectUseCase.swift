//
//  ConnectUseCase.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/15.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import CoreBluetooth
import RxBluetoothKit
import RxSwift

protocol ConnectUseCase {
    var targetDevice: Observable<Result<CubeModel, ToioBluetoothError>> { get }
    func loadDevice()
    func loadStop()
}

class ConnectUseCaseImpl: ConnectUseCase {
    private static let CubeName = ["toio Core Cube"]

    fileprivate var manager: CBCentralManager?
    private let disposeBag = DisposeBag()
    private var targetSubject = PublishSubject<Result<CubeModel, ToioBluetoothError>>()

    var targetDevice: Observable<Result<CubeModel, ToioBluetoothError>> {
        return targetSubject
    }

    func loadDevice() {
        let scheduler = CurrentThreadScheduler.instance
        var retDevice: Cube?
        BluetoothService.shared
            .scanningOutput
            .subscribeOn(scheduler)
            .flatMap { [weak self] event -> Observable<ScannedPeripheral> in
                switch event {
                case let .success(scanned):
                    return Observable.from(optional: scanned)
                case let .error(e):
                    self?.targetSubject.onNext(Result.error(e))
                    return Observable.empty()
                }
            }
            .filter { (device) -> Bool in
                guard let name = device.peripheral.name else {
                    return false
                }
                return ConnectUseCaseImpl.CubeName.contains(name)
            }
            .take(1)
            .flatMap { (scanned) -> Observable<Cube> in
                retDevice = Cube(peripheral: scanned.peripheral)
                return retDevice!.connect()
            }
            .flatMap { cube -> Observable<FirmwareVersion> in
                cube.getFirmwareVersion()
            }
            .flatMap { (version) -> Observable<Cube> in
                retDevice?.firmwareVersion = version
                return Observable.from(optional: retDevice)
            }
            .subscribe(
                onNext: { [weak self] _ in
                    guard let self = self else {
                        return
                    }
                    self.targetSubject.onNext(Result.success(CubeModel(peripheral: retDevice!)))
                },
                onError: { [weak self] error in
                    self?.targetSubject.onNext(Result.error(error as? ToioBluetoothError ?? ToioBluetoothError(type: .unknown)))
                }
            ).disposed(by: disposeBag)
        BluetoothService.shared.startScaning(serviceUUIDs: [CBUUID(string: "10B20100-5B3B-4571-9508-CF3EFCD7BBAE".uppercased())], duration: 15)
    }

    func loadStop() {
        BluetoothService.shared.stopScaning()
    }
}
