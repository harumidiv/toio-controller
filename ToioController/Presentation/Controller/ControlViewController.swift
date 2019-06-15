//
//  ControlViewController.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/14.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import UIKit

class ControlViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "toio controller"

        let informationButton: UIBarButtonItem = UIBarButtonItem(title: "⚙", style: .plain, target: self, action: #selector(showInformation(_:)))
        navigationItem.rightBarButtonItem = informationButton
    }

    @objc func showInformation(_ sender: UIBarButtonItem) {
        navigationController?.pushViewController(InformationViewController(), animated: true)
    }
}
