//
//  ConnectUseCase.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/15.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import CoreBluetooth

protocol ConnectUseCase: AnyObject {
    /// 接続結果の通知先。メインスレッドで呼ばれる
    var onTargetDevice: ((Result<CubeModel, ToioBluetoothError>) -> Void)? { get set }
    func loadDevice()
    func loadStop()
}

class ConnectUseCaseImpl: ConnectUseCase {
    var onTargetDevice: ((Result<CubeModel, ToioBluetoothError>) -> Void)?

    /// 接続処理中のcubeを保持する
    private var connectingCube: Cube?

    func loadDevice() {
        connectingCube = nil
        BluetoothService.shared.startScaning(serviceUUIDs: [CBUUID(string: CubeService.toioTrolley.uuid)], duration: 15) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case let .success(peripheral):
                // 接続するデバイスがtoioか判定する
                guard self.connectingCube == nil, let name = peripheral.name, name.contains("toio") else {
                    return
                }
                BluetoothService.shared.stopScaning()
                self.connect(peripheral: peripheral)
            case let .error(e):
                self.onTargetDevice?(.error(e))
            }
        }
    }

    func loadStop() {
        BluetoothService.shared.stopScaning()
    }

    private func connect(peripheral: CBPeripheral) {
        let cube = Cube(peripheral: peripheral)
        connectingCube = cube
        cube.onDisconnect = {
            // cubeの接続が切れたらNotificationを飛ばす
            NotificationCenter.default.post(name: .cubeDissconect, object: nil)
        }
        cube.connect { [weak self] result in
            switch result {
            case let .success(cube):
                cube.getFirmwareVersion { [weak self] result in
                    self?.connectingCube = nil
                    switch result {
                    case let .success(version):
                        cube.firmwareVersion = version
                        self?.onTargetDevice?(.success(CubeModel(peripheral: cube)))
                    case let .error(e):
                        cube.disconnect()
                        self?.onTargetDevice?(.error(e))
                    }
                }
            case let .error(e):
                self?.connectingCube = nil
                self?.onTargetDevice?(.error(e))
            }
        }
    }
}

extension Notification.Name {
    static var cubeDissconect = Notification.Name("cubeDissconect")
}
