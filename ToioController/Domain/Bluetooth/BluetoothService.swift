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

    func startScaning() {}

    func stopScaning() {}

    func getPeripheral() {}
}
