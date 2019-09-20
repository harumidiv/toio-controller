//
//  ConnectMockPresenter.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/08/22.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import Foundation

class ConnectMockPresenterImpl: ConnectPresenter {
    func checkBluetoothAuthorization() -> Bool {
        return true
    }

    weak var output: ConnectPresenterOutput?

    init(output: ConnectPresenterOutput) {
        self.output = output
    }

    func checkPhoneState() {
        output?.showController(cube: nil)
    }

    func loadDevice() {}
}
