//
//  Control.swift
//  ToioController
//
//  Created by しじみ100% on 2019/09/21.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import CoreBluetooth
import Foundation

class Control {
    func writeValue(characteristics: CubeCharacteristic, writeType: CBCharacteristicWriteType, value: Data) {
        fatalError("Create write logic")
    }

    func moterStop(count: Int, service: CBService) {
        fatalError("Stop processing when changing control type")
    }
}
