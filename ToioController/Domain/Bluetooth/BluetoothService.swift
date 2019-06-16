//
//  BluetoothService.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/15.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import CoreBluetooth
import RxBluetoothKit
import RxSwift

final class BluetoothService {
    static let shared = BluetoothService()

    private let scanningSubjet = PublishSubject<Result<ScannedPeripheral, ToioBluetoothError>>()
    private var scannedPeripheral = [UUID: ScannedPeripheral]()
    private var scannningDisposable: Disposable?
    private let scheduler: ConcurrentDispatchQueueScheduler
    private let disposeBag = DisposeBag()

    private let queue = DispatchQueue(label: "harumidiv.ToioController", qos: .userInitiated)
    private lazy var centralManager: CentralManager = {
        CentralManager(queue: queue)
    }()

    // MARK: - Public outputs

    var manager: CentralManager {
        return centralManager
    }

    var bluetoothState: BluetoothState {
        return manager.state
    }

    var scanningOutput: Observable<Result<ScannedPeripheral, ToioBluetoothError>> {
        return scanningSubjet.share(replay: 1, scope: .forever).asObservable()
    }

    // MARK: - Initialization

    private init() {
        let timerQueue = DispatchQueue(label: "ToioController")
        scheduler = ConcurrentDispatchQueueScheduler(queue: timerQueue)
    }

    deinit {
        scannningDisposable?.dispose()
    }

    // MARK: - Public methods

    func startScaning(serviceUUIDs: [CBUUID]? = nil, duration: TimeInterval = 15) {
        centralManager.attach()

        scannningDisposable = manager.observeState()
            .startWith(centralManager.state)
            .filter { $0 == .poweredOn }
            .subscribeOn(MainScheduler.instance)
            .timeout(duration, scheduler: scheduler)
            .flatMap { [weak self] _ -> Observable<ScannedPeripheral> in
                guard let self = self else {
                    return Observable.empty()
                }
                return self.centralManager.scanForPeripherals(withServices: serviceUUIDs)
            }.subscribe(onNext: { [weak self] scannedPeripheral in
                self?.scannedPeripheral[scannedPeripheral.peripheral.peripheral.identifier] = scannedPeripheral
                self?.scanningSubjet.onNext(Result.success(scannedPeripheral))
            }, onError: { [weak self] error in
                if let rxError = error as? RxError, case RxError.timeout = rxError {
                    self?.scanningSubjet.onNext(Result.error(ToioBluetoothError(type: .scanTimeout)))
                } else {
                    self?.scanningSubjet.onNext(Result.error(ToioBluetoothError(type: .unknown)))
                }
            })
    }

    func stopScaning() {
        scannningDisposable?.dispose()
    }
}
