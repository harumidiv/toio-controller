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
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
        }
    }

    let url: URL
    let titleText: String

    init(url: URL, titleText: String) {
        self.url = url
        self.titleText = titleText

        super.init(nibName: String(describing: WebViewController.self), bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = titleText
    }
}
