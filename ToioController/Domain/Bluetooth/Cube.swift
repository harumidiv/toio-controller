//
//  Cube.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/15.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import CoreBluetooth

final class Cube: NSObject, ToioPeripheral {
    typealias ServiceType = CubeService

    let peripheral: CBPeripheral
    var firmwareVersion: FirmwareVersion = .init(major: 0, minor: 0, patch: 0)

    /// 接続確立後にcubeとの接続が切れた時に呼ばれる(disconnect()による切断では呼ばれない)
    var onDisconnect: (() -> Void)?

    private var characteristics = [CBUUID: CBCharacteristic]()
    private var connectCompletion: ((Result<Cube, ToioBluetoothError>) -> Void)?
    private var firmwareVersionCompletion: ((Result<FirmwareVersion, ToioBluetoothError>) -> Void)?

    init(peripheral: CBPeripheral) {
        self.peripheral = peripheral
        super.init()
    }

    // MARK: - Public methods

    /// 接続し、サービスとキャラクタリスティックの探索が終わったらcompletionを呼ぶ
    func connect(completion: @escaping (Result<Cube, ToioBluetoothError>) -> Void) {
        connectCompletion = completion
        BluetoothService.shared.connect(peripheral, completion: { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success:
                self.peripheral.delegate = self
                self.peripheral.discoverServices([CBUUID(string: CubeService.toioTrolley.uuid)])
            case let .error(error):
                self.finishConnect(.error(error))
            }
        }, onDisconnect: { [weak self] _ in
            guard let self = self else {
                return
            }
            if self.connectCompletion != nil {
                // 探索中に切断された
                self.finishConnect(.error(ToioBluetoothError(type: .unknown)))
            } else {
                self.finishFirmwareVersion(.error(ToioBluetoothError(type: .firmwareVersionFaild)))
                self.onDisconnect?()
            }
        })
    }

    func disconnect() {
        connectCompletion = nil
        firmwareVersionCompletion = nil
        BluetoothService.shared.cancelConnection(peripheral)
    }

    func writeValue(characteristic: CubeCharacteristic, data: Data, type: CBCharacteristicWriteType) {
        guard peripheral.state == .connected, let c = characteristics[CBUUID(string: characteristic.uuid)] else {
            return
        }
        peripheral.writeValue(data, for: c, type: type)
    }

    func getFirmwareVersion(completion: @escaping (Result<FirmwareVersion, ToioBluetoothError>) -> Void) {
        guard let c = characteristics[CBUUID(string: CubeCharacteristic.configulation.uuid)] else {
            completion(.error(ToioBluetoothError(type: .firmwareVersionFaild)))
            return
        }
        firmwareVersionCompletion = completion
        if c.isNotifying {
            requestFirmwareVersion(characteristic: c)
        } else {
            // 通知の有効化が完了したらperipheral(_:didUpdateNotificationStateFor:error:)で要求を書き込む
            peripheral.setNotifyValue(true, for: c)
        }
    }

    static func parseConfigulationValue(data: Data?) -> (id: String, value: String)? {
        guard let hex = data?.hexEncodedString() else {
            return nil
        }
        let idBytes = 2
        let sequenceBytes = 2
        return (id: String(hex.prefix(idBytes)), value: String(hex.suffix(hex.count - (idBytes + sequenceBytes))))
    }

    // MARK: - Private methods

    private func requestFirmwareVersion(characteristic: CBCharacteristic) {
        let byteArray: [UInt8] = [0x02, 0x01]
        peripheral.writeValue(Data(byteArray), for: characteristic, type: .withResponse)
    }

    private func finishConnect(_ result: Result<Cube, ToioBluetoothError>) {
        guard let completion = connectCompletion else {
            return
        }
        connectCompletion = nil
        if case .error = result {
            BluetoothService.shared.cancelConnection(peripheral)
        }
        completion(result)
    }

    private func finishFirmwareVersion(_ result: Result<FirmwareVersion, ToioBluetoothError>) {
        guard let completion = firmwareVersionCompletion else {
            return
        }
        firmwareVersionCompletion = nil
        completion(result)
    }
}

// MARK: - CBPeripheralDelegate

extension Cube: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        let serviceUUID = CBUUID(string: CubeService.toioTrolley.uuid)
        guard error == nil, let service = peripheral.services?.first(where: { $0.uuid == serviceUUID }) else {
            finishConnect(.error(ToioBluetoothError(type: .unknown)))
            return
        }
        let uuids = CubeService.CharacteristicType.allCases.map { CBUUID(string: $0.uuid) }
        peripheral.discoverCharacteristics(uuids, for: service)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard error == nil, let discovered = service.characteristics, !discovered.isEmpty else {
            finishConnect(.error(ToioBluetoothError(type: .unknown)))
            return
        }
        discovered.forEach { characteristics[$0.uuid] = $0 }
        finishConnect(.success(self))
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        guard characteristic.uuid == CBUUID(string: CubeCharacteristic.configulation.uuid), firmwareVersionCompletion != nil else {
            return
        }
        guard error == nil else {
            finishFirmwareVersion(.error(ToioBluetoothError(type: .firmwareVersionFaild)))
            return
        }
        requestFirmwareVersion(characteristic: characteristic)
    }

    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil, characteristic.uuid == CBUUID(string: CubeCharacteristic.configulation.uuid) {
            finishFirmwareVersion(.error(ToioBluetoothError(type: .firmwareVersionFaild)))
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard characteristic.uuid == CBUUID(string: CubeCharacteristic.configulation.uuid), error == nil else {
            return
        }
        // 0x82: BLEプロトコルバージョンの応答
        guard let parsed = Cube.parseConfigulationValue(data: characteristic.value), parsed.id == "82" else {
            return
        }
        let version = FirmwareVersion(version: parsed.value.hexStringtoAscii())
        finishFirmwareVersion(.success(version))
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
    case configulation = "10B201FF-5B3B-4571-9508-CF3EFCD7BBAE"

    var uuid: String {
        return rawValue
    }
}
