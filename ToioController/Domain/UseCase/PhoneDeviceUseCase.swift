//
//  PhoneDeviceUseCase.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/15.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import CoreBluetooth
import Foundation
import UIKit

protocol PhoneDeviceUsecase: AnyObject {
    func getBattery() -> Float
    func getBluetoothState(completion: @escaping (CBManagerState) -> Void)
    func checkBluetoothAuthorization() -> Bool
}

class PhoneDeviceUsecaseImpl: PhoneDeviceUsecase {
    func checkBluetoothAuthorization() -> Bool {
        return CBCentralManager.authorization == .allowedAlways
    }

    func getBattery() -> Float {
        defer {
            // メソッドを抜けた時にバッテリーモニタリングを不可に戻す
            UIDevice.current.isBatteryMonitoringEnabled = false
        }
        UIDevice.current.isBatteryMonitoringEnabled = true
        return UIDevice.current.batteryLevel
    }

    func getBluetoothState(completion: @escaping (CBManagerState) -> Void) {
        BluetoothService.shared.observeState(completion)
    }
}
