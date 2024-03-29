//
//  ControlViewController.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/14.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import CoreBluetooth
import RxBluetoothKit
import RxSwift
import UIKit

class ControlViewController: UIViewController {
    let cubeModel: CubeModel?
    var zigzagTimer: Timer!
    var dualshock: Dualshock?

    private var isFirstZigZag: Bool = true

    @IBOutlet weak var controllerInfo: UIButton!
    @IBOutlet weak var upButton: DirectionalPadUpButton!
    @IBOutlet weak var downButton: DirectionalPadDownButton!
    @IBOutlet weak var rightButton: DirectionalPadRightButton!
    @IBOutlet weak var leftButton: DirectionalPadLeftButton!
    @IBOutlet weak var honeButton: RoundButton!
    @IBOutlet weak var backButton: RoundButton!
    @IBOutlet weak var rotateButton: RoundButton!
    @IBOutlet weak var zigzagButton: RoundButton!

    @IBOutlet weak var buttonBackgroundView: UIView! {
        didSet {
            buttonBackgroundView.layer.cornerRadius = buttonBackgroundView.frame.width / 2
        }
    }

    @IBOutlet weak var controlBackgroundView: UIView! {
        didSet {
            controlBackgroundView.layer.cornerRadius = controlBackgroundView.frame.width / 2
        }
    }

    // MARK: - Initializer

    init(cubeModel: CubeModel?) {
        self.cubeModel = cubeModel
        super.init(nibName: String(describing: ControlViewController.self), bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        cubeModel?.peripheral.disconnect()
    }

    // MARK: LifeCycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

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
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dualshock = Dualshock(cubeModel: cubeModel, output: self)

        title = "toio controller"

        let informationButton = UIBarButtonItem(image: #imageLiteral(resourceName: "setting"), style: .plain, target: self, action: #selector(showInformation(_:)))
        navigationItem.rightBarButtonItem = informationButton
        updateControllerInfo()
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

    @objc func showInformation(_ sender: UIBarButtonItem) {
        navigationController?.pushViewController(InformationViewController(), animated: true)
    }

    @IBAction func upStart(_ sender: Any) {
        var writeData: [UInt8] = [0x01, 0x01, 0x01]
        var speed = UserStore.up
        if speed <= 10 {
            speed = 11
        }
        let data = UInt8(String(speed))!
        writeData += [data]
        writeData += [0x02]
        writeData += [0x01]
        writeData += [data]
        writeValue(characteristics: .moter, writeType: .withoutResponse, value: Data(writeData))
    }

    @IBAction func upStop(_ sender: Any) {
        writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.moterStop)
    }

    @IBAction func downStart(_ sender: Any) {
        var writeData: [UInt8] = [0x01, 0x01, 0x02]
        var speed = UserStore.down
        if speed <= 10 {
            speed = 11
        }
        let data = UInt8(String(speed))!
        writeData += [data]
        writeData += [0x02]
        writeData += [0x02]
        writeData += [data]
        writeValue(characteristics: .moter, writeType: .withoutResponse, value: Data(writeData))
    }

    @IBAction func downStop(_ sender: Any) {
        writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.moterStop)
    }

    @IBAction func rightStart(_ sender: Any) {
        var writeData: [UInt8] = [0x01, 0x01, 0x01]
        var speed = UserStore.right
        if speed <= 10 {
            speed = 11
        }
        let data = UInt8(String(speed))!
        writeData += [data]
        writeData += [0x02]
        writeData += [0x01]
        writeData += [data / 2]
        writeValue(characteristics: .moter, writeType: .withoutResponse, value: Data(writeData))
    }

    @IBAction func rightStop(_ sender: Any) {
        writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.moterStop)
    }

    @IBAction func leftStart(_ sender: Any) {
        var writeData: [UInt8] = [0x01, 0x01, 0x01]
        var speed = UserStore.left
        if speed <= 10 {
            speed = 11
        }
        let data = UInt8(String(speed))!
        writeData += [data / 2]
        writeData += [0x02]
        writeData += [0x01]
        writeData += [data]
        writeValue(characteristics: .moter, writeType: .withoutResponse, value: Data(writeData))
    }

    @IBAction func leftStop(_ sender: Any) {
        writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.moterStop)
    }

    @IBAction func backStart(_ sender: UIButton) {
        // moter
        writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.BackData.moter)

        // light
        writeValue(characteristics: .light, writeType: .withResponse, value: Constant.BackData.light)

        // sound
        writeValue(characteristics: .sound, writeType: .withResponse, value: Constant.BackData.sound)
        upButton.isEnabled = false
        downButton.isEnabled = false
        leftButton.isEnabled = false
        rightButton.isEnabled = false
        honeButton.isEnabled = false
        rotateButton.isEnabled = false
        zigzagButton.isEnabled = false
    }

    @IBAction func backStop(_ sender: UIButton) {
        writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.moterStop)
        writeValue(characteristics: .light, writeType: .withResponse, value: Data([0x01]))
        writeValue(characteristics: .sound, writeType: .withResponse, value: Data([0x01]))

        upButton.isEnabled = true
        downButton.isEnabled = true
        leftButton.isEnabled = true
        rightButton.isEnabled = true
        honeButton.isEnabled = true
        rotateButton.isEnabled = true
        zigzagButton.isEnabled = true
    }

    @IBAction func honeStart(_ sender: UIButton) {
        writeValue(characteristics: .sound, writeType: .withResponse, value: Constant.WriteData.hone)
        upButton.isEnabled = false
        downButton.isEnabled = false
        leftButton.isEnabled = false
        rightButton.isEnabled = false
        backButton.isEnabled = false
        rotateButton.isEnabled = false
        zigzagButton.isEnabled = false
    }

    @IBAction func honeStop(_ sender: UIButton) {
        writeValue(characteristics: .sound, writeType: .withResponse, value: Data([0x01]))
        upButton.isEnabled = true
        downButton.isEnabled = true
        leftButton.isEnabled = true
        rightButton.isEnabled = true
        backButton.isEnabled = true
        rotateButton.isEnabled = true
        zigzagButton.isEnabled = true
    }

    @IBAction func rotateStart(_ sender: Any) {
        writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.rotate)
        upButton.isEnabled = false
        downButton.isEnabled = false
        leftButton.isEnabled = false
        rightButton.isEnabled = false
        backButton.isEnabled = false
        honeButton.isEnabled = false
        zigzagButton.isEnabled = false
    }

    @IBAction func rotateStop(_ sender: Any) {
        writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.moterStop)
        upButton.isEnabled = true
        downButton.isEnabled = true
        leftButton.isEnabled = true
        rightButton.isEnabled = true
        backButton.isEnabled = true
        honeButton.isEnabled = true
        zigzagButton.isEnabled = true
    }

    var zigzagFlug = false
    @IBAction func zigzagStart(_ sender: Any) {
        // タップしてから0.3秒開いてしまうので調整用
        if isFirstZigZag {
            writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.ZigzagData.right)
            isFirstZigZag = false
        }

        zigzagTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { _ in
            print("呼ばれたよ")
            if self.zigzagFlug {
                self.zigzagFlug = false
                self.writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.ZigzagData.right)
            } else {
                self.zigzagFlug = true
                self.writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.ZigzagData.left)
            }
        })

        upButton.isEnabled = false
        downButton.isEnabled = false
        leftButton.isEnabled = false
        rightButton.isEnabled = false
        backButton.isEnabled = false
        honeButton.isEnabled = false
        rotateButton.isEnabled = false
    }

    @IBAction func zigzagStop(_ sender: Any) {
        zigzagTimer.invalidate()
        isFirstZigZag = true
        zigzagFlug = false
        writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.moterStop)
        upButton.isEnabled = true
        downButton.isEnabled = true
        leftButton.isEnabled = true
        rightButton.isEnabled = true
        backButton.isEnabled = true
        honeButton.isEnabled = true
        rotateButton.isEnabled = true
    }

    @IBAction func optionTapped(_ sender: UIButton) {
        navigationController?.pushViewController(SettingViewController(titleText: R.string.localizeString.navigationSetting()), animated: true)
    }

    @IBAction func dualshockControlTapped(_ sender: Any) {
        if dualshock?.hasconnectionDevice() ?? false {
            let dualshockVC = DualshockViewController()
            dualshockVC.controller = dualshock
            dualshockVC.dismissAction = { [weak self] in
                self?.dualshock?.isOperationPossible = false
            }
            present(dualshockVC, animated: true, completion: nil)
        } else {
            R.string.localizeString.controllerDialogMessage()
            showInformation(message: R.string.localizeString.controllerDialogMessage(), buttonText: R.string.localizeString.controllerDialogButtonText())
        }
    }

    private func writeValue(characteristics: CubeCharacteristic, writeType: CBCharacteristicWriteType, value: Data) {
        _ = cubeModel?.peripheral.writeValue(characteristic: characteristics, data: value, type: writeType).subscribe(onNext: { _ in })
    }

    private func updateControllerInfo() {
        if dualshock?.hasconnectionDevice() ?? false {
            controllerInfo.setImage(R.image.controllerON(), for: .normal)
        } else {
            controllerInfo.setImage(R.image.controllerOFF(), for: .normal)
        }
    }
}

extension ControlViewController: DualshockOutput {
    func showSettingScreen() {
        if let topController = UIApplication.topViewController() {
            if topController.className == "ControlViewController" {
                navigationController?.pushViewController(SettingViewController(titleText: R.string.localizeString.navigationSetting()), animated: true)
            }
        }
    }
}
