//
//  ModeA.swift
//  ToioController
//
//  Created by しじみ100% on 2019/09/21.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import CoreBluetooth
import Foundation

class ModeA: Control {
    var angle: Int = 0
    var isStop: Bool = false
    var alreadyStopWrite: Bool = false
    let cubeModel: CubeModel

    init(cubeModel: CubeModel) {
        self.cubeModel = cubeModel
    }

    func leftJoyStickDirectionControl(x: Float, y: Float) {
        let oblique = sqrt(x * x + y * y)
        if oblique < 0.1 {
            isStop = true
        } else {
            isStop = false
        }

        var r: Double = Double(atan2(0.0 - x, 0.0 - y))
        if r < 0 {
            r += 2 * Double.pi
        }
        angle = Int(r * 360 / (2 * Double.pi))
    }

    func writeAndleBytes() {
        if isStop {
            if !alreadyStopWrite {
                writeValue(characteristics: .moter, writeType: .withResponse, value: Constant.Direction.stop)
                alreadyStopWrite = true
                angle = 4444
                return
            }
        }

        if angle == 4444 {
            writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.Direction.stop)
            return
        }
        alreadyStopWrite = false

        if angle >= 23, angle <= 67 {
            writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.Direction.bottomLeft)
        } else if angle >= 68, angle <= 112 {
            writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.Direction.left)
        } else if angle >= 113, angle <= 157 {
            writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.Direction.upperLeft)
        } else if angle >= 158, angle <= 202 {
            writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.Direction.up)
        } else if angle >= 203, angle <= 247 {
            writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.Direction.upperRigit)
        } else if angle >= 248, angle <= 292 {
            writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.Direction.right)
        } else if angle >= 293, angle <= 337 {
            writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.Direction.bottomRight)
        } else {
            writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.Direction.down)
        }
    }

    override func moterStop(count: Int, service: CBService) {
        writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.Direction.stop)
    }

    override func writeValue(characteristics: CubeCharacteristic, writeType: CBCharacteristicWriteType, value: Data) {
        _ = cubeModel.peripheral.writeValue(characteristic: characteristics, data: value, type: writeType).subscribe(onNext: { _ in })
    }
}
