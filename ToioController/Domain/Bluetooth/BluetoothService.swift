//
//  BluetoothService.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/15.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import CoreBluetooth

/// CBCentralManagerをラップし、スキャン・接続・状態監視を提供する
/// delegateはメインキューで呼ばれる
final class BluetoothService: NSObject {
    static let shared = BluetoothService()

    typealias ScanHandler = (Result<CBPeripheral, ToioBluetoothError>) -> Void
    typealias ConnectHandler = (Result<CBPeripheral, ToioBluetoothError>) -> Void
    typealias DisconnectHandler = (Error?) -> Void

    private lazy var centralManager = CBCentralManager(delegate: self, queue: .main)

    private var scanHandler: ScanHandler?
    private var scanServiceUUIDs: [CBUUID]?
    private var scanTimeoutWorkItem: DispatchWorkItem?
    private var stateHandlers = [(CBManagerState) -> Void]()
    private var connectHandlers = [UUID: ConnectHandler]()
    private var disconnectHandlers = [UUID: DisconnectHandler]()

    // MARK: - Public outputs

    var bluetoothState: CBManagerState {
        return centralManager.state
    }

    // MARK: - Initialization

    override private init() {
        super.init()
    }

    // MARK: - Public methods

    /// 状態が確定したら(unknown/resetting以外になったら)一度だけhandlerを呼ぶ
    func observeState(_ handler: @escaping (CBManagerState) -> Void) {
        let state = centralManager.state
        if state == .unknown || state == .resetting {
            stateHandlers.append(handler)
        } else {
            handler(state)
        }
    }

    /// ペリフェラルを見つけるたびにhandlerを呼ぶ。durationを過ぎるとscanTimeoutを返して停止する
    func startScaning(serviceUUIDs: [CBUUID]? = nil, duration: TimeInterval = 15, handler: @escaping ScanHandler) {
        stopScaning()
        scanHandler = handler
        scanServiceUUIDs = serviceUUIDs

        let timeout = DispatchWorkItem { [weak self] in
            guard let self = self, let handler = self.scanHandler else {
                return
            }
            self.stopScaning()
            handler(.error(ToioBluetoothError(type: .scanTimeout)))
        }
        scanTimeoutWorkItem = timeout
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: timeout)

        // poweredOnでなければcentralManagerDidUpdateStateで開始する
        if centralManager.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: serviceUUIDs, options: nil)
        }
    }

    func stopScaning() {
        scanTimeoutWorkItem?.cancel()
        scanTimeoutWorkItem = nil
        scanHandler = nil
        scanServiceUUIDs = nil
        if centralManager.state == .poweredOn, centralManager.isScanning {
            centralManager.stopScan()
        }
    }

    func connect(_ peripheral: CBPeripheral, completion: @escaping ConnectHandler, onDisconnect: @escaping DisconnectHandler) {
        connectHandlers[peripheral.identifier] = completion
        disconnectHandlers[peripheral.identifier] = onDisconnect
        centralManager.connect(peripheral, options: nil)
    }

    func cancelConnection(_ peripheral: CBPeripheral) {
        connectHandlers[peripheral.identifier] = nil
        disconnectHandlers[peripheral.identifier] = nil
        centralManager.cancelPeripheralConnection(peripheral)
    }
}

// MARK: - CBCentralManagerDelegate

extension BluetoothService: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        let state = central.state
        if state != .unknown, state != .resetting {
            let handlers = stateHandlers
            stateHandlers.removeAll()
            handlers.forEach { $0(state) }
        }

        if state == .poweredOn, scanHandler != nil {
            central.scanForPeripherals(withServices: scanServiceUUIDs, options: nil)
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        scanHandler?(.success(peripheral))
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectHandlers.removeValue(forKey: peripheral.identifier)?(.success(peripheral))
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        disconnectHandlers[peripheral.identifier] = nil
        connectHandlers.removeValue(forKey: peripheral.identifier)?(.error(ToioBluetoothError(type: .unknown)))
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        connectHandlers[peripheral.identifier] = nil
        disconnectHandlers.removeValue(forKey: peripheral.identifier)?(error)
    }
}
