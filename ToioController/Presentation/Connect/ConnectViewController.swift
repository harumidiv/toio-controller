//
//  ConnectViewController.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/15.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import Lottie
import UIKit

class ConnectViewController: UIViewController {
    @IBOutlet weak var animationView: AnimationView! {
        didSet {
            animationView.animation = Animation.named("448-ripple-loading-animation")
            animationView.loopMode = .loop
        }
    }

    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var searchButton: SearchButton!
    lazy var presenter: ConnectPresenter = {
        let presenter = ConnectInjector.container.resolve(ConnectPresenter.self, argument: self as ConnectPresenterOutput)!
        return presenter
    }()

    private lazy var wireframe: ConnectWireframe = ConnectInjector.container.resolve(ConnectWireframe.self)!

    var controller: Dualshock!

    // MARK: - LifeCycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(viewWillEnterForeground(
            notification:
        )), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "探索中..."

        let informationButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "setting"), style: .plain, target: self, action: #selector(showInformation(_:)))
        navigationItem.rightBarButtonItem = informationButton
    }

    // MARK: - Event

    @objc func showInformation(_ sender: UIBarButtonItem) {
        wireframe.showInformation(vc: self)
    }

    @objc func viewWillEnterForeground(notification: Notification) {
        if presenter.checkBluetoothAuthorization() {
            return
        }

        showInformation(title: "Bluetooth Permission", message: "コントローラを使用するにはBluetoothの許可が必要です", buttonText: "許可する") {
            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }

    @IBAction func searchStart(_ sender: UIButton) {
        searchButton.isHidden = true
        animationView.play()
        animationView.isHidden = false
        descriptionLabel.text = "近くにあるcubeを検索中です"
        presenter.checkPhoneState()
    }
}

extension ConnectViewController: ConnectPresenterOutput {
    func showBluetoothPermissionAlert() {
        DispatchQueue.main.async {
            self.showInformation(title: "Bluetooth Permission", message: "コントローラを使用するにはBluetoothの許可が必要です", buttonText: "設定に移動") {
                if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }

    func showController(cube: CubeModel?) {
        DispatchQueue.main.async {
            self.searchButton.isHidden = false
            self.animationView.stop()
            self.animationView.isHidden = true
            self.searchButton.setTitle("cubeを探す", for: .normal)
            self.searchButton.backgroundColor = UIColor(appColor: .search)
            self.wireframe.showController(vc: self, model: cube)
        }
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
        animationView.stop()
        animationView.isHidden = true
        searchButton.setTitle("もう一度探す", for: .normal)
        searchButton.backgroundColor = UIColor(appColor: .again)
        descriptionLabel.text = "cubeの電源を入れて\n探すボタンを押してください"
    }
}
