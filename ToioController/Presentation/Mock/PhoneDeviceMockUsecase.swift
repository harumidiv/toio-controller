//
//  PhoneDeviceMockUsecase.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/10/06.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import CoreBluetooth
import Foundation

class PhoneDeviceMockUsecase: PhoneDeviceUsecase {
    func getBattery() -> Float {
        return 100
    }

    func getBluetoothState(completion: @escaping (CBManagerState) -> Void) {
        completion(.poweredOn)
    }

    func checkBluetoothAuthorization() -> Bool {
        return true
    }
}
