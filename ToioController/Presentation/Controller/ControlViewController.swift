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

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "toio controller"

        let informationButton: UIBarButtonItem = UIBarButtonItem(title: "⚙", style: .plain, target: self, action: #selector(showInformation(_:)))
        navigationItem.rightBarButtonItem = informationButton
    }

    // MARK: - Event

    @objc func showInformation(_ sender: UIBarButtonItem) {
        navigationController?.pushViewController(InformationViewController(), animated: true)
    }

    @IBAction func upStart(_ sender: Any) {
        writeValue(characteristics: .moter, writeType: .withoutResponse, value: Data([0x01, 0x01, 0x01, 0x64, 0x02, 0x01, 0x64]))
    }

    @IBAction func upStop(_ sender: Any) {}

    @IBAction func downStart(_ sender: Any) {}
    @IBAction func downStop(_ sender: Any) {}

    @IBAction func rightStart(_ sender: Any) {}

    @IBAction func rightStop(_ sender: Any) {}

    @IBAction func leftStart(_ sender: Any) {}
    @IBAction func leftStop(_ sender: Any) {}

    private func writeValue(characteristics: CubeCharacteristic, writeType: CBCharacteristicWriteType, value: Data) {
        cubeModel.peripheral.writeValue(characteristic: characteristics, data: value, type: writeType).subscribe(onNext: { _ in })
    }
}
