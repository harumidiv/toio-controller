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

    // MARK: - Initializer

    init(cubeModel: CubeModel) {
        self.cubeModel = cubeModel
        super.init(nibName: String(describing: ControlViewController.self), bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("削除されたよ")
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
        writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.up)
    }

    @IBAction func upStop(_ sender: Any) {
        writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.moterStop)
    }

    @IBAction func downStart(_ sender: Any) {
        writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.down)
    }

    @IBAction func downStop(_ sender: Any) {
        writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.moterStop)
    }

    @IBAction func rightStart(_ sender: Any) {
        writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.right)
    }

    @IBAction func rightStop(_ sender: Any) {
        writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.moterStop)
    }

    @IBAction func leftStart(_ sender: Any) {
        writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.left)
    }

    @IBAction func leftStop(_ sender: Any) {
        writeValue(characteristics: .moter, writeType: .withoutResponse, value: Constant.WriteData.moterStop)
    }

    private func writeValue(characteristics: CubeCharacteristic, writeType: CBCharacteristicWriteType, value: Data) {
        _ = cubeModel.peripheral.writeValue(characteristic: characteristics, data: value, type: writeType).subscribe(onNext: { _ in })
    }
}
