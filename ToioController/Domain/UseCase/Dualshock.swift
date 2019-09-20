//
//  Dualshock.swift
//  ToioController
//
//  Created by しじみ100% on 2019/09/20.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import CoreBluetooth
import Foundation
import GameController

class Dualshock {
    let cubeModel: CubeModel

    var zigzagTimer: Timer!
    var zigzagFlug = false
    var isFirstZigZag = true

    // MARK: - Initializer

    init(cubeModel: CubeModel) {
        self.cubeModel = cubeModel
        setupGameController()
    }

    private func setupGameController() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(handleControllerDidConnect),
            name: NSNotification.Name.GCControllerDidConnect, object: nil
        )

        NotificationCenter.default.addObserver(
            self, selector: #selector(handleControllerDidDisconnect),
            name: NSNotification.Name.GCControllerDidDisconnect, object: nil
        )
        guard let controller = GCController.controllers().first else {
            return
        }
        registerGameController(controller)
    }

    // アプリ起動中に新規でコントローラが接続された際に飛んでくる
    @objc func handleControllerDidConnect(_ notification: Notification) {
        guard let gameController = notification.object as? GCController else {
            return
        }

        registerGameController(gameController)
    }

    // アプリ起動中にコントローラとの接続が切れると呼ばれる
    @objc func handleControllerDidDisconnect(_ notification: Notification) {
        guard let gameController = notification.object as? GCController else {
            return
        }

        unregisterGameController()

        for controller: GCController in GCController.controllers() where gameController != controller {
            registerGameController(controller)
        }
    }

    func registerGameController(_ gameController: GCController) {
        if let gamepad = gameController.extendedGamepad {
            rightButtonControl(gamepad: gamepad)
        }
    }

    // MARK: - Button ▲ ▫️ ✖︎ ●

    private func rightButtonControl(gamepad: GCExtendedGamepad) {
        let triangleButton: GCControllerButtonInput = gamepad.buttonY
        let circleButton: GCControllerButtonInput = gamepad.buttonB
        let crossButton: GCControllerButtonInput = gamepad.buttonA
        let rectButton: GCControllerButtonInput = gamepad.buttonX

        triangleButton.valueChangedHandler = { (_: GCControllerButtonInput, _: Float, _ pressed: Bool) -> Void in
            if pressed {
                print("▲")
                self.writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.rotate)
            } else {
                self.writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.moterStop)
            }
        }
        rectButton.valueChangedHandler = { (_: GCControllerButtonInput, _: Float, _ pressed: Bool) -> Void in
            if pressed {
                print("■")
                // moter
                self.writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.BackData.moter)

                // light
                self.writeValue(characteristics: .light, writeType: .withResponse, value: Constant.BackData.light)

                // sound
                self.writeValue(characteristics: .sound, writeType: .withResponse, value: Constant.BackData.sound)
            } else {
                self.writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.moterStop)
                self.writeValue(characteristics: .light, writeType: .withResponse, value: Data([0x01]))
                self.writeValue(characteristics: .sound, writeType: .withResponse, value: Data([0x01]))
            }
        }

        crossButton.valueChangedHandler = { (_: GCControllerButtonInput, _: Float, _ pressed: Bool) -> Void in
            if pressed {
                print("✖︎")
                if self.isFirstZigZag {
                    self.writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.ZigzagData.right)
                    self.isFirstZigZag = false
                }
                self.zigzagTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { _ in
                    print("呼ばれたよ")
                    if self.zigzagFlug {
                        self.zigzagFlug = false
                        self.writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.ZigzagData.right)
                    } else {
                        self.zigzagFlug = true
                        self.writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.ZigzagData.left)
                    }
                })
            } else {
                self.isFirstZigZag = true
                self.zigzagTimer.invalidate()
                self.writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.moterStop)
            }
        }

        circleButton.valueChangedHandler = { (_: GCControllerButtonInput, _: Float, _ pressed: Bool) -> Void in
            if pressed {
                print("●")
                self.writeValue(characteristics: .sound, writeType: .withResponse, value: Constant.WriteData.hone)
            } else {
                self.writeValue(characteristics: .sound, writeType: .withResponse, value: Data([0x01]))
            }
        }
    }

    func unregisterGameController() {
        // TODO: Controllerがdisconnectされた時にAlertを表示する
        print("disconnect")
    }

    private func writeValue(characteristics: CubeCharacteristic, writeType: CBCharacteristicWriteType, value: Data) {
        _ = cubeModel.peripheral.writeValue(characteristic: characteristics, data: value, type: writeType).subscribe(onNext: { _ in })
    }
}
