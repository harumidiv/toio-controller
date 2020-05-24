//
//  DualshockViewController.swift
//  ToioController
//
//  Created by 佐川 晴海 on 2020/05/24.
//  Copyright © 2020 佐川晴海. All rights reserved.
//

import UIKit

class DualshockViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func appControllerTapped(_ sender: Any) {
        // TODO: タイマーを止める必要がある
        dismiss(animated: true, completion: nil)
    }
}
