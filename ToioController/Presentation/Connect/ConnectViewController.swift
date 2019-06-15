//
//  ConnectViewController.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/15.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import UIKit

class ConnectViewController: UIViewController {
    @IBOutlet weak var indicator: UIActivityIndicatorView! {
        didSet {
            indicator.startAnimating()
        }
    }

    lazy var presenter: ConnectPresenter = {
        let presenter = ConnectInjector.container.resolve(ConnectPresenter.self, argument: self as ConnectPresenterOutput)!
        return presenter
    }()

    private lazy var wireframe: ConnectWireframe = ConnectInjector.container.resolve(ConnectWireframe.self)!

    lazy var p = ConnectPresenterImpl(output: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "探索中..."
        presenter.checkPhoneState()
    }
}

extension ConnectViewController: ConnectPresenterOutput {
    func showController(cube: CubeModel) {
        wireframe.showController(vc: self, model: cube)
    }

    func showBatteryError() {
        showInformation(message: "iPhoneの充電が少なくなっています\n充電してから遊んでください", buttonText: "閉じる")
    }

    func showBluetoothError() {
        showInformation(message: "bluetoothの設定がoffになっています\nonに切り替えてください", buttonText: "閉じる")
    }

    func showDevice() {
        // TODO:
        print("デバイス発見")
        presenter.loadDevice()
    }
}
