//
//  ModeB.swift
//  ToioController
//
//  Created by しじみ100% on 2019/09/21.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import Foundation

import CoreBluetooth

class ModeB: Control {
    var nowService: CBService?
    var steeringAngle: Float = 0
    var speedValue: Int = 0
    var alreadyStopWrite: Bool = false
    let cubeModel: CubeModel?

    init(cubeModel: CubeModel?) {
        self.cubeModel = cubeModel
    }

    func speedControl(y: Float) {
        let speed = Int(y * 100)
        speedValue = speed
    }

    func steeringControl(x: Float) {
        steeringAngle = x / 2.5
    }

    func writeSteeringBytes() {
        var direction: UInt8

        if speedValue == 0, steeringAngle == 0 {
            if !alreadyStopWrite {
                writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.Direction.stop)
                alreadyStopWrite = true
                return
            }
        }

        if speedValue > 0 {
            direction = 0x01
        } else {
            direction = 0x02
        }

        var writeBytes: [UInt8] = [0x01, 0x01]
        writeBytes.append(direction)

        if steeringAngle < -0.1 {
            if abs(steeringAngle) == 1 {
                writeBytes.append(0x00)
            } else {
                let v = abs(Int(Float(speedValue) * steeringAngle))
                writeBytes.append(UInt8(v))
            }
        } else {
            writeBytes.append(UInt8(abs(speedValue)))
        }

        writeBytes.append(0x02)
        writeBytes.append(direction)

        if steeringAngle > 0.1 {
            if abs(steeringAngle) == 1 {
                writeBytes.append(0x00)
            } else {
                let v = abs(Int(Float(speedValue) * steeringAngle))
                writeBytes.append(UInt8(v))
            }
        } else {
            writeBytes.append(UInt8(abs(speedValue)))
        }
        writeValue(characteristics: .moter, writeType: .withoutResponse, value: Data(writeBytes))

        alreadyStopWrite = false
    }

    override func moterStop(count: Int, service: CBService) {
        writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.Direction.stop)
    }

    override func writeValue(characteristics: CubeCharacteristic, writeType: CBCharacteristicWriteType, value: Data) {
        _ = cubeModel?.peripheral.writeValue(characteristic: characteristics, data: value, type: writeType).subscribe(onNext: { _ in })
    }
}
