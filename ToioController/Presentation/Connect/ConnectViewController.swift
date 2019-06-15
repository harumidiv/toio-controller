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

    lazy var p = ConnectPresenterImpl(output: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "探索中..."
        presenter.checkPhoneState()
    }
}

extension ConnectViewController: ConnectPresenterOutput {
    func showBatteryError() {
        print("バッテリー不足")
    }

    func showBluetoothError() {
        print("bluetoothエラー")
    }

    func showDevice() {
        print("デバイス発見")
    }
}
