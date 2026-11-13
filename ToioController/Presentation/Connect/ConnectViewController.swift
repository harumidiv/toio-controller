//
//  ConnectViewController.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/15.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import SwiftUI
import UIKit

/// 接続画面。表示はSwiftUIのConnectViewで行い、ここではPresenterとの連携と画面遷移を扱う
class ConnectViewController: UIViewController {
    private let viewState = ConnectViewState()

    lazy var presenter: ConnectPresenter = ConnectInjector.container.resolve(ConnectPresenter.self, argument: self as ConnectPresenterOutput)!

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
        view.backgroundColor = .white
        embed(ConnectView(
            state: viewState,
            onSearch: { [weak self] in self?.searchStart() },
            onInformation: { [weak self] in self?.showInformation() }
        ))
    }

    // MARK: - Event

    private func showInformation() {
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

    private func searchStart() {
        viewState.phase = .scanning
        presenter.checkPhoneState()
    }
}

extension ConnectViewController: ConnectPresenterOutput {
    func showErrorDialog() {
        DispatchQueue.main.async {
            self.showInformation(title: R.string.localizeString.connectionAlertBluetoothCatheTitle(),
                                 message: R.string.localizeString.connectionAlertBluetoothCatheMessage(),
                                 buttonText: R.string.localizeString.connectionAlertBluetoothClose())
            {
                self.viewState.phase = .retry
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
                self.viewState.phase = .idle
                self.wireframe.showController(vc: self, model: cube)
            } else {
                // TODO: ダイアログを表示する
                self.showInformation(title: R.string.localizeString.connectionAlertLowVersionTitle(),
                                     message: R.string.localizeString.connectionAlertLowVersionMessage(),
                                     buttonText: R.string.localizeString.connectionAlertBluetoothClose())
                {
                    self.viewState.phase = .idle
                    self.wireframe.showController(vc: self, model: cube)
                }
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
        viewState.phase = .retry
    }
}
