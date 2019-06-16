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
    let cubeModel: CubeModel
    let userDefault = UserDefaults.standard

    // MARK: - Initializer

    init(cubeModel: CubeModel) {
        self.cubeModel = cubeModel
        super.init(nibName: String(describing: ControlViewController.self), bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        cubeModel.peripheral.disconnect()
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
        if userDefault.object(forKey: "down") != nil {
            var writeData: [UInt8] = [0x01, 0x01, 0x01]
            var speed = userDefault.integer(forKey: "down")
            if speed <= 10 {
                speed = 11
            }
            let data = UInt8(String(speed))!
            writeData += [data]
            writeData += [0x02]
            writeData += [0x01]
            writeData += [0x00]
            writeValue(characteristics: .moter, writeType: .withoutResponse, value: Data(writeData))
        } else {
            writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.right)
        }
    }

    @IBAction func rightStop(_ sender: Any) {
        writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.moterStop)
    }

    @IBAction func leftStart(_ sender: Any) {
        if userDefault.object(forKey: "down") != nil {
            var writeData: [UInt8] = [0x01, 0x01, 0x01]
            var speed = userDefault.integer(forKey: "down")
            if speed <= 10 {
                speed = 11
            }
            let data = UInt8(String(speed))!
            writeData += [0x00]
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
        writeValue(characteristics: .moter, writeType: .withoutResponse, value: Data([0x01, 0x01, 0x02, 0x20, 0x02, 0x02, 0x20]))
        // light
        writeValue(characteristics: .light, writeType: .withResponse, value: Data([0x03, 0x00, 0x01, 0x01, 0xFF, 0x00, 0x00]))
        // sound
        writeValue(characteristics: .sound, writeType: .withResponse, value: Data([0x03, 0x00, 0x03, 0x3F, 0x40, 0x7F, 0x3F, 0xFF, 0x1E, 0x01, 0xFF, 0x7F]))
    }

    @IBAction func backStop(_ sender: UIButton) {
        writeValue(characteristics: .moter, writeType: .withoutResponse, value: Data([0x01, 0x01, 0x02, 0x00, 0x02, 0x02, 0x00]))
        writeValue(characteristics: .light, writeType: .withResponse, value: Data([0x01]))
        writeValue(characteristics: .sound, writeType: .withResponse, value: Data([0x01]))
    }

    @IBAction func honeStart(_ sender: UIButton) {
        // TODO: 長いブザーのがなるようにする
        writeValue(characteristics: .sound, writeType: .withResponse, value: Data([0x03, 0x00, 0x03, 0x3F, 0x40, 0x7F, 0x3F, 0xFF, 0x1E, 0x01, 0xFF, 0x7F]))
    }

    @IBAction func honeStop(_ sender: UIButton) {
        writeValue(characteristics: .sound, writeType: .withResponse, value: Data([0x01]))
    }

    private func writeValue(characteristics: CubeCharacteristic, writeType: CBCharacteristicWriteType, value: Data) {
        _ = cubeModel.peripheral.writeValue(characteristic: characteristics, data: value, type: writeType).subscribe(onNext: { _ in })
    }
}
