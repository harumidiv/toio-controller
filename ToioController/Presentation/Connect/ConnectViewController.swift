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

    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var searchButton: SearchButton!
    lazy var presenter: ConnectPresenter = {
        let presenter = ConnectInjector.container.resolve(ConnectPresenter.self, argument: self as ConnectPresenterOutput)!
        return presenter
    }()

    private lazy var wireframe: ConnectWireframe = ConnectInjector.container.resolve(ConnectWireframe.self)!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "探索中..."

        let informationButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "setting"), style: .plain, target: self, action: #selector(showInformation(_:)))
        navigationItem.rightBarButtonItem = informationButton
    }

    @objc func showInformation(_ sender: UIBarButtonItem) {
        wireframe.showInformation(vc: self)
    }

    @IBAction func searchStart(_ sender: UIButton) {
        searchButton.isHidden = true
        descriptionLabel.text = "近くにあるcubeを検索中です"
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
        presenter.loadDevice()
    }

    func showTimeout() {
        searchButton.isHidden = false
        searchButton.setTitle("もう一度探す", for: .normal)
        searchButton.backgroundColor = UIColor(appColor: .again)
        descriptionLabel.text = "cubeの電源を入れて\n探すボタンを押してください"
    }
}
