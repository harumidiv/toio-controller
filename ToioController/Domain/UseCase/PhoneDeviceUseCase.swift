//
//  PhoneDeviceUseCase.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/15.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import Foundation
import RxBluetoothKit
import RxSwift

protocol PhoneDeviceUsecase: AnyObject {
    func getBattery() -> Observable<Float>
    func getBluetoothState() -> Observable<BluetoothState>
}

class PhoneDeviceUsecaseImpl: PhoneDeviceUsecase {
    func getBattery() -> Observable<Float> {
        defer {
            // メソッドを抜けた時にバッテリーモニタリングを不可に戻す
            UIDevice.current.isBatteryMonitoringEnabled = false
        }
        UIDevice.current.isBatteryMonitoringEnabled = true
        return Observable.just(UIDevice.current.batteryLevel)
    }

    func getBluetoothState() -> Observable<BluetoothState> {
        if BluetoothService.shared.bluetoothState == .unknown {
            return BluetoothService.shared.manager.observeState()
        } else {
            return Observable.of(BluetoothService.shared.bluetoothState)
        }
    }
}
