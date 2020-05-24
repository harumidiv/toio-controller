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

enum ControlType {
    case modeA
    case modeB
    case modeC
}

protocol DualshockOutput: AnyObject {
    func showSettingScreen()
}

class Dualshock {
    let cubeModel: CubeModel?

    var zigzagTimer: Timer!
    var zigzagFlug = false
    var isFirstZigZag = true
    let modeA: ModeA
    let modeB: ModeB
    var modeATimer: Timer?
    var modeBTimer: Timer?

    let controlType: ControlType
    var isButtonEvent: Bool = false

    weak var output: DualshockOutput?

    // MARK: - Initializer

    init(cubeModel: CubeModel?, output: DualshockOutput) {
        self.cubeModel = cubeModel
        controlType = .modeB
        self.output = output

        modeA = ModeA(cubeModel: cubeModel)
        modeB = ModeB(cubeModel: cubeModel)
        setupGameController()
    }

    // MARK: - PublicMethod

    func removeTimer() {
        modeATimer?.invalidate()
        modeBTimer?.invalidate()
    }

    func setTimer() {
        switch controlType {
        case .modeA:
            modeATimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(writeDirectionMoterControl(_:)), userInfo: nil, repeats: true)
        case .modeB:
            modeBTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(writeSteeringMoterControl(_:)), userInfo: nil, repeats: true)
        case .modeC:
            // TODO:
            break
        }
    }

    // MARK: - PrivateMethod

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

        switch controlType {
        case .modeA:
            modeATimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(writeDirectionMoterControl(_:)), userInfo: nil, repeats: true)
        case .modeB:
            modeBTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(writeSteeringMoterControl(_:)), userInfo: nil, repeats: true)
        case .modeC:
            // TODO:
            break
        }

        registerGameController(controller)
    }

    @objc func writeDirectionMoterControl(_ timer: Timer!) {
        if isButtonEvent {
            return
        }
        modeA.writeAndleBytes()
    }

    @objc func writeSteeringMoterControl(_ timer: Timer!) {
        if isButtonEvent {
            return
        }
        modeB.writeSteeringBytes()
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
            thumbstick(gamepad: gamepad)
            directionPad(gamepad: gamepad)
            settingButton(gamepad: gamepad)
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
                self.isButtonEvent = true
                self.writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.rotate)
            } else {
                self.isButtonEvent = false
                self.writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.moterStop)
            }
        }

        rectButton.valueChangedHandler = { (_: GCControllerButtonInput, _: Float, _ pressed: Bool) -> Void in
            if pressed {
                print("■")
                self.isButtonEvent = true
                // moter
                self.writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.BackData.moter)

                // light
                self.writeValue(characteristics: .light, writeType: .withResponse, value: Constant.BackData.light)

                // sound
                self.writeValue(characteristics: .sound, writeType: .withResponse, value: Constant.BackData.sound)
            } else {
                self.isButtonEvent = false
                self.writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.moterStop)
                self.writeValue(characteristics: .light, writeType: .withResponse, value: Data([0x01]))
                self.writeValue(characteristics: .sound, writeType: .withResponse, value: Data([0x01]))
            }
        }

        crossButton.valueChangedHandler = { (_: GCControllerButtonInput, _: Float, _ pressed: Bool) -> Void in
            if pressed {
                print("✖︎")
                self.isButtonEvent = true
                if self.isFirstZigZag {
                    self.writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.ZigzagData.right)
                    self.isFirstZigZag = false
                }
                self.zigzagTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { _ in
                    if self.zigzagFlug {
                        self.zigzagFlug = false
                        self.writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.ZigzagData.right)
                    } else {
                        self.zigzagFlug = true
                        self.writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.ZigzagData.left)
                    }
                })
            } else {
                self.isButtonEvent = false
                self.isFirstZigZag = true
                self.zigzagTimer.invalidate()
                self.writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.moterStop)
            }
        }

        circleButton.valueChangedHandler = { (_: GCControllerButtonInput, _: Float, _ pressed: Bool) -> Void in
            if pressed {
                print("●")
                self.isButtonEvent = true
                self.writeValue(characteristics: .sound, writeType: .withResponse, value: Constant.WriteData.hone)
            } else {
                self.isButtonEvent = false
                self.writeValue(characteristics: .sound, writeType: .withResponse, value: Data([0x01]))
            }
        }
    }

    // MARK: - 🕹 Thumbstick 🕹

    private func thumbstick(gamepad: GCExtendedGamepad) {
        let leftThumbstick = gamepad.leftThumbstick
        let rightThumbstick = gamepad.rightThumbstick

        leftThumbstick.valueChangedHandler = { (_: GCControllerDirectionPad, _: Float, y: Float) -> Void in
//            self.modeA.leftJoyStickDirectionControl(x: x, y: y)

            self.modeB.speedControl(y: y)
        }

        rightThumbstick.valueChangedHandler = { (_: GCControllerDirectionPad, x: Float, _: Float) -> Void in
            self.modeB.steeringControl(x: x)
        }
    }

    // MARK: - ⬆️⬇️➡️⬅️

    private func directionPad(gamepad: GCExtendedGamepad) {
        let directionPad = gamepad.dpad

        directionPad.valueChangedHandler = { (_: GCControllerDirectionPad, _ x: Float, _ y: Float) -> Void in
            if x == 0, y == 0 {
                self.writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.Direction.stop)
                self.isButtonEvent = false
                return
            }
            self.isButtonEvent = true

            if x == 1.0, y == 1.0 {
                self.writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.Direction.upperRigit)
                return
            } else if x == -1.0, y == -1.0 {
                self.writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.Direction.bottomLeft)
                return
            } else if x == 1.0, y == -1.0 {
                self.writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.Direction.bottomRight)
                return
            } else if x == -1.0, y == 1.0 {
                self.writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.Direction.upperLeft)
                return
            }

            // 上下左右

            if x == 1.0 {
                self.writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.Direction.right)
            }
            if x == -1.0 {
                self.writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.Direction.left)
            }
            if y == 1.0 {
                self.writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.Direction.up)
            }
            if y == -1.0 {
                self.writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.Direction.down)
            }
        }
    }

    private func settingButton(gamepad: GCExtendedGamepad) {
        if #available(iOS 13.0, *) {
            let menuButton = gamepad.buttonMenu
            menuButton.valueChangedHandler = { (_: GCControllerButtonInput, _: Float, _ pressed: Bool) -> Void in
                if pressed {
                    print("pressed")
                    // TODO: Thumsthickのコントロール方法を制御できるようにする
                    // 設定用の新規画面を作成
                }
            }
        }
        if #available(iOS 13.0, *) {
            let shareButton = gamepad.buttonOptions
            shareButton?.valueChangedHandler = { (_: GCControllerButtonInput, _: Float, _ pressed: Bool) -> Void in
                if pressed {
                    self.output?.showSettingScreen()
                }
            }
        }
    }

    func unregisterGameController() {
        // TODO: Controllerがdisconnectされた時にAlertを表示する
        print("disconnect")
    }

    func hasconnectionDevice() -> Bool {
        guard let _ = GCController.controllers().first else {
            return false
        }
        return true
    }

    private func writeValue(characteristics: CubeCharacteristic, writeType: CBCharacteristicWriteType, value: Data) {
        _ = cubeModel?.peripheral.writeValue(characteristic: characteristics, data: value, type: writeType).subscribe(onNext: { _ in })
    }
}
