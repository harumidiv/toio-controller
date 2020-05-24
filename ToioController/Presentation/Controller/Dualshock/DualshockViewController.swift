//
//  DualshockViewController.swift
//  ToioController
//
//  Created by 佐川 晴海 on 2020/05/24.
//  Copyright © 2020 佐川晴海. All rights reserved.
//

import UIKit

class DualshockViewController: UIViewController {
    var controller: Dualshock!
    var dismissAction: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        controller.isOperationPossible = true
    }

    @IBAction func appControllerTapped(_ sender: Any) {
        controller.removeTimer()
        dismissAction?()
        dismiss(animated: true, completion: nil)
    }
}

extension DualshockViewController: DualshockOutput {
    func showSettingScreen() {
        if let topController = UIApplication.topViewController() {
            if topController.className == "ControlViewController" {
                navigationController?.pushViewController(SettingViewController(titleText: R.string.localizeString.navigationSetting()), animated: true)
            }
        }
    }
}
