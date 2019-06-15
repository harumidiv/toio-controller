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

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "探索中..."
    }
}
