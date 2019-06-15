//
//  ConnectUseCase.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/15.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import RxSwift
import RxBluetoothKit
import CoreBluetooth

protocol ConnectUseCase {
    var targetDevice: Observable<Result<CubeModel, ToioBluetoothError>> {get}
    func loadDevice()
    func loadStop()
}

class ConnectUseCaseImpl: ConnectUseCase {
    private static let CubeName =  ["toio Core Cube"]
    
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
        .flatMap{ [weak self] event -> Observable<ScannedPeripheral> in
            switch event {
            case let .success(scanned):
                return Observable.from(optional: scanned)
            case let .error(e):
                self?.targetSubject.onNext(Result.error(e))
                return Observable.empty()
            }
        }
        .filter{ [weak self] in
            guard let name = $0.peripheral.name else {
                return false
            }
            return ConnectUseCaseImpl.CubeName.contains(name)
        }
        .flatMap{
            retDevice = Cube(peripheral: scanned.peripheral)
            return retDevice
        }
    }
    
    func loadStop() {
        
    }
}
