//
//  ControlViewController.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/14.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import CoreBluetooth
import SwiftUI
import UIKit

/// コントローラ画面。表示はSwiftUIのControlViewで行い、ここではcubeへの書き込みと画面遷移を扱う
class ControlViewController: UIViewController {
    let cubeModel: CubeModel?
    var zigzagTimer: Timer?
    var dualshock: Dualshock?

    private let viewState = ControlViewState()
    private var isFirstZigZag: Bool = true
    private var zigzagFlug = false

    // MARK: - Initializer

    init(cubeModel: CubeModel?) {
        self.cubeModel = cubeModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        zigzagTimer?.invalidate()
        cubeModel?.peripheral.disconnect()
    }

    // MARK: LifeCycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // この画面は左端のメニューで操作するのでナビゲーションバーを隠す
        navigationController?.setNavigationBarHidden(true, animated: animated)
        // 十字キーが画面の左端に近いので、操作中に誤ってスワイプで戻らないようにする
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(viewDidEnterBackground(_:)),
                                               name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(viewDidEnterForground(_:)),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(cubeDissconect(_:)),
                                               name: .cubeDissconect,
                                               object: nil)
        updateControllerInfo()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "toio controller"
        dualshock = Dualshock(cubeModel: cubeModel, output: self)
        embedControlView()
        updateControllerInfo()
    }

    private func embedControlView() {
        let controlView = ControlView(
            state: viewState,
            onDirection: { [weak self] direction, isPressed in
                self?.handleDirection(direction, isPressed: isPressed)
            },
            onAction: { [weak self] action, isPressed in
                self?.handleAction(action, isPressed: isPressed)
            },
            onBack: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            },
            onGamepad: { [weak self] in
                self?.showDualshock()
            },
            onSettings: { [weak self] in
                self?.showSetting()
            },
            onInformation: { [weak self] in
                self?.showInformation()
            }
        )
        let hostingController = UIHostingController(rootView: controlView)
        hostingController.view.backgroundColor = .clear
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        hostingController.didMove(toParent: self)
    }

    // MARK: - Event

    @objc func cubeDissconect(_ notification: Notification) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }

        print("cubeとの接続が切れました")
    }

    @objc func viewDidEnterBackground(_ notification: Notification) {}

    @objc func viewDidEnterForground(_ notification: Notification) {
        updateControllerInfo()
    }

    private func showInformation() {
        navigationController?.pushViewController(InformationViewController(), animated: true)
    }

    private func showSetting() {
        navigationController?.pushViewController(SettingViewController(titleText: R.string.localizeString.navigationSetting()), animated: true)
    }

    private func showDualshock() {
        if dualshock?.hasconnectionDevice() ?? false {
            let dualshockVC = DualshockViewController()
            dualshockVC.controller = dualshock
            dualshockVC.dismissAction = { [weak self] in
                self?.dualshock?.isOperationPossible = false
            }
            present(dualshockVC, animated: true, completion: nil)
        } else {
            showInformation(message: R.string.localizeString.controllerDialogMessage(), buttonText: R.string.localizeString.controllerDialogButtonText())
        }
    }

    // MARK: - 十字キー

    private func handleDirection(_ direction: ControlDirection, isPressed: Bool) {
        guard isPressed else {
            // アクション中はアクション側がモーターを制御するので停止を送らない
            guard viewState.activeAction == nil else {
                return
            }
            writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.moterStop)
            return
        }
        switch direction {
        case .up:
            upStart()
        case .down:
            downStart()
        case .right:
            rightStart()
        case .left:
            leftStart()
        }
    }

    private func upStart() {
        let speed = speedByte(UserStore.up)
        writeValue(characteristics: .moter, writeType: .withoutResponse, value: Data([0x01, 0x01, 0x01, speed, 0x02, 0x01, speed]))
    }

    private func downStart() {
        let speed = speedByte(UserStore.down)
        writeValue(characteristics: .moter, writeType: .withoutResponse, value: Data([0x01, 0x01, 0x02, speed, 0x02, 0x02, speed]))
    }

    private func rightStart() {
        let speed = speedByte(UserStore.right)
        writeValue(characteristics: .moter, writeType: .withoutResponse, value: Data([0x01, 0x01, 0x01, speed, 0x02, 0x01, speed / 2]))
    }

    private func leftStart() {
        let speed = speedByte(UserStore.left)
        writeValue(characteristics: .moter, writeType: .withoutResponse, value: Data([0x01, 0x01, 0x01, speed / 2, 0x02, 0x01, speed]))
    }

    /// 設定値の速度(10以下は動かないので11に補正)を書き込み用の値にする
    private func speedByte(_ speed: Int) -> UInt8 {
        return UInt8(String(max(speed, 11)))!
    }

    // MARK: - アクション

    private func handleAction(_ action: ControlAction, isPressed: Bool) {
        if isPressed {
            // 押している間は他のボタンを無効にする
            viewState.activeAction = action
            switch action {
            case .back:
                writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.BackData.moter)
                writeValue(characteristics: .light, writeType: .withResponse, value: Constant.BackData.light)
                writeValue(characteristics: .sound, writeType: .withResponse, value: Constant.BackData.sound)
            case .horn:
                writeValue(characteristics: .sound, writeType: .withResponse, value: Constant.WriteData.hone)
            case .spin:
                writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.rotate)
            case .zigzag:
                zigzagStart()
            }
        } else {
            switch action {
            case .back:
                writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.moterStop)
                writeValue(characteristics: .light, writeType: .withResponse, value: Data([0x01]))
                writeValue(characteristics: .sound, writeType: .withResponse, value: Data([0x01]))
            case .horn:
                writeValue(characteristics: .sound, writeType: .withResponse, value: Data([0x01]))
            case .spin:
                writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.moterStop)
            case .zigzag:
                zigzagStop()
            }
            viewState.activeAction = nil
        }
    }

    private func zigzagStart() {
        // タップしてから0.3秒開いてしまうので調整用
        if isFirstZigZag {
            writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.ZigzagData.right)
            isFirstZigZag = false
        }

        zigzagTimer?.invalidate()
        zigzagTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { [weak self] _ in
            guard let self = self else {
                return
            }
            if self.zigzagFlug {
                self.zigzagFlug = false
                self.writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.ZigzagData.right)
            } else {
                self.zigzagFlug = true
                self.writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.ZigzagData.left)
            }
        })
    }

    private func zigzagStop() {
        zigzagTimer?.invalidate()
        zigzagTimer = nil
        isFirstZigZag = true
        zigzagFlug = false
        writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.moterStop)
    }

    // MARK: - Private

    private func writeValue(characteristics: CubeCharacteristic, writeType: CBCharacteristicWriteType, value: Data) {
        cubeModel?.peripheral.writeValue(characteristic: characteristics, data: value, type: writeType)
    }

    private func updateControllerInfo() {
        viewState.isGamepadConnected = dualshock?.hasconnectionDevice() ?? false
    }
}

extension ControlViewController: DualshockOutput {
    func showSettingScreen() {
        if let topController = UIApplication.topViewController() {
            if topController.className == "ControlViewController" {
                showSetting()
            }
        }
    }
}
