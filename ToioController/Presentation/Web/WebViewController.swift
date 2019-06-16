//
//  WebViewController.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/16.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            let urlRequest = URLRequest(url: URL(string: "https://harumidiv.github.io/toio-controller/")!)
            webView.load(urlRequest)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "プライバシーポリシー"
    }
}
