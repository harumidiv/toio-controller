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
    let userDefault = UserDefaults.standard

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

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        cubeModel?.peripheral.disconnect()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "toio controller"

        let informationButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "setting"), style: .plain, target: self, action: #selector(showInformation(_:)))
        navigationItem.rightBarButtonItem = informationButton
    }

    // MARK: - Event

    @objc func showInformation(_ sender: UIBarButtonItem) {
        navigationController?.pushViewController(InformationViewController(), animated: true)
    }

    @IBAction func upStart(_ sender: Any) {
        if userDefault.object(forKey: "up") != nil {
            var writeData: [UInt8] = [0x01, 0x01, 0x01]
            var speed = userDefault.integer(forKey: "up")
            if speed <= 10 {
                speed = 11
            }
            let data = UInt8(String(speed))!
            writeData += [data]
            writeData += [0x02]
            writeData += [0x01]
            writeData += [data]
            writeValue(characteristics: .moter, writeType: .withoutResponse, value: Data(writeData))

        } else {
            writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.up)
        }
    }

    @IBAction func upStop(_ sender: Any) {
        writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.moterStop)
    }

    @IBAction func downStart(_ sender: Any) {
        if userDefault.object(forKey: "down") != nil {
            var writeData: [UInt8] = [0x01, 0x01, 0x02]
            var speed = userDefault.integer(forKey: "down")
            if speed <= 10 {
                speed = 11
            }
            let data = UInt8(String(speed))!
            writeData += [data]
            writeData += [0x02]
            writeData += [0x02]
            writeData += [data]
            writeValue(characteristics: .moter, writeType: .withoutResponse, value: Data(writeData))
        } else {
            writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.down)
        }
    }

    @IBAction func downStop(_ sender: Any) {
        writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.moterStop)
    }

    @IBAction func rightStart(_ sender: Any) {
        if userDefault.object(forKey: "right") != nil {
            var writeData: [UInt8] = [0x01, 0x01, 0x01]
            var speed = userDefault.integer(forKey: "right")
            if speed <= 10 {
                speed = 11
            }
            let data = UInt8(String(speed))!
            writeData += [data]
            writeData += [0x02]
            writeData += [0x01]
            writeData += [data / 2]
            writeValue(characteristics: .moter, writeType: .withoutResponse, value: Data(writeData))
        } else {
            writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.right)
        }
    }

    @IBAction func rightStop(_ sender: Any) {
        writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.moterStop)
    }

    @IBAction func leftStart(_ sender: Any) {
        if userDefault.object(forKey: "left") != nil {
            var writeData: [UInt8] = [0x01, 0x01, 0x01]
            var speed = userDefault.integer(forKey: "left")
            if speed <= 10 {
                speed = 11
            }
            let data = UInt8(String(speed))!
            writeData += [data / 2]
            writeData += [0x02]
            writeData += [0x01]
            writeData += [data]
            writeValue(characteristics: .moter, writeType: .withoutResponse, value: Data(writeData))
        } else {
            writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.left)
        }
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

    @IBAction func zigzagStart(_ sender: Any) {
        print("start")
        upButton.isEnabled = false
        downButton.isEnabled = false
        leftButton.isEnabled = false
        rightButton.isEnabled = false
        backButton.isEnabled = false
        honeButton.isEnabled = false
        rotateButton.isEnabled = false
    }

    @IBAction func zigzagStop(_ sender: Any) {
        print("stop")
        upButton.isEnabled = true
        downButton.isEnabled = true
        leftButton.isEnabled = true
        rightButton.isEnabled = true
        backButton.isEnabled = true
        honeButton.isEnabled = true
        rotateButton.isEnabled = true
    }

    @IBAction func optionTapped(_ sender: UIButton) {
        navigationController?.pushViewController(SettingViewController(titleText: "設定"), animated: true)
    }

    private func writeValue(characteristics: CubeCharacteristic, writeType: CBCharacteristicWriteType, value: Data) {
        _ = cubeModel?.peripheral.writeValue(characteristic: characteristics, data: value, type: writeType).subscribe(onNext: { _ in })
    }
}
