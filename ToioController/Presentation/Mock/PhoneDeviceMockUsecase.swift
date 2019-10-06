//
//  ConnectMockUseCase.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/10/06.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import Foundation
import RxBluetoothKit
import RxSwift

class PhoneDeviceMockUsecase: PhoneDeviceUsecase {
    func getBattery() -> Observable<Float> {
        return Observable.just(100)
    }

    func getBluetoothState() -> Observable<BluetoothState> {
        return Observable.just(.poweredOn)
    }

    func checkBluetoothAuthorization() -> Bool {
        return true
    }
}
