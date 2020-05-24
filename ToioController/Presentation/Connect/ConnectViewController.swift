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

    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.text = R.string.localizeString.connectionDescriptionPrev()
        }
    }

    @IBOutlet weak var searchButton: SearchButton! {
        didSet {
            searchButton.setTitle(R.string.localizeString.connectionSearchbutton(), for: .normal)
        }
    }

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
        title = R.string.localizeString.navigationbarConnection()

        let informationButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "setting"), style: .plain, target: self, action: #selector(showInformation(_:)))
        navigationItem.rightBarButtonItem = informationButton
    }

    // MARK: - Event

    @objc func showInformation(_ sender: UIBarButtonItem) {
        showTimeout()
        wireframe.showInformation(vc: self)
    }

    @objc func viewWillEnterForeground(notification: Notification) {
        showTimeout()
        if presenter.checkBluetoothAuthorization() {
            return
        }

        showInformation(title: R.string.localizeString.connectionAlertBluetooth(), message: R.string.localizeString.connectionAlertBluetoothMessage(), buttonText: R.string.localizeString.connectionAlertButton()) {
            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }

    @IBAction func searchStart(_ sender: UIButton) {
        searchButton.isHidden = true
        animationView.play()
        animationView.isHidden = false
        descriptionLabel.text = R.string.localizeString.connectionDescriotionScanning()
        presenter.checkPhoneState()
    }
}

extension ConnectViewController: ConnectPresenterOutput {
    func showErrorDialog() {
        DispatchQueue.main.async {
            self.showInformation(title: "⚠️エラー",
                                 message: "bluetoothのキャッシュが残っていますiPhoneを再起動してください",
                                 buttonText: R.string.localizeString.connectionAlertBluetoothClose()) {
                self.searchButton.isHidden = false
                self.animationView.stop()
                self.animationView.isHidden = true
                self.searchButton.setTitle(R.string.localizeString.connectionButtonRescan(), for: .normal)
                self.searchButton.backgroundColor = UIColor(appColor: .again)
                self.descriptionLabel.text = R.string.localizeString.connectionDescriptionPrev()
            }
        }
    }

    func showBluetoothPermissionAlert() {
        DispatchQueue.main.async {
            self.showInformation(title: R.string.localizeString.connectionAlertBluetooth(), message: R.string.localizeString.connectionAlertBluetoothMessage(), buttonText: R.string.localizeString.connectionAlertBluetoothClose()) {
                if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }

    func showController(cube: CubeModel?) {
        DispatchQueue.main.async {
            if (cube?.peripheral.firmwareVersion)! > FirmwareVersion(major: 2, minor: 2, patch: 0) {
                self.searchButton.isHidden = false
                self.animationView.stop()
                self.animationView.isHidden = true
                self.searchButton.setTitle(R.string.localizeString.connectionSearchbutton(), for: .normal)
                self.searchButton.backgroundColor = UIColor(appColor: .search)
                self.wireframe.showController(vc: self, model: cube)
            } else {
                //TODO ダイアログを表示する
                print("NG")
            }
        }
    }

    func showBatteryError() {
        showTimeout()
        showInformation(message: R.string.localizeString.connectionAlertLessbatteryMessage(), buttonText: R.string.localizeString.connectionAlertLessbatteryClose())
    }

    func showBluetoothError() {
        showInformation(message: R.string.localizeString.connectionAlertBluetoothMessage(), buttonText: R.string.localizeString.connectionAlertBluetoothClose())
    }

    func showDevice() {
        presenter.loadDevice()
    }

    func showTimeout() {
        searchButton.isHidden = false
        animationView.stop()
        animationView.isHidden = true
        searchButton.setTitle(R.string.localizeString.connectionButtonRescan(), for: .normal)
        searchButton.backgroundColor = UIColor(appColor: .again)
        descriptionLabel.text = R.string.localizeString.connectionDescriptionPrev()
    }
}
