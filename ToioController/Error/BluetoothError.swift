//
//  BluetoothError.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/15.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import Foundation

struct ToioBluetoothError: Error {
    let type: ToioBluetoothErrorType
}

enum ToioBluetoothErrorType: Int {
    case scanTimeout
    case unknown
    case firmwareVersionFaild
}
