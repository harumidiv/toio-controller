//
//  DualshockViewController.swift
//  ToioController
//
//  Created by 佐川 晴海 on 2020/05/24.
//  Copyright © 2020 佐川晴海. All rights reserved.
//

import StoreKit
import UIKit

class DualshockViewController: UIViewController {
    var controller: Dualshock!
    var dismissAction: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        openAppReviewWindow()
        controller.setTimer()
        controller.isOperationPossible = true

        NotificationCenter.default.addObserver(
            self, selector: #selector(handleControllerDidDisconnect),
            name: NSNotification.Name.GCControllerDidDisconnect, object: nil
        )
    }

    @IBAction func appControllerTapped(_ sender: Any) {
        controller.removeTimer()
        dismissAction?()
        dismiss(animated: true, completion: nil)
    }

    // コントローラとの接続が解除された場合
    @objc func handleControllerDidDisconnect(_ notification: Notification) {
        controller.removeTimer()
        dismissAction?()
        dismiss(animated: true, completion: nil)
    }

    private func openAppReviewWindow() {
        if !UserStore.appReview {
            SKStoreReviewController.requestReview()
            UserStore.appReview = true
        }
    }
}

extension DualshockViewController: DualshockOutput {
    func showSettingScreen() {
        // Nop
    }
}
