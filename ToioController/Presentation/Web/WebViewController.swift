//
//  WebViewController.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/15.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import SwiftUI
import UIKit

/// Webページを表示する画面。表示はSwiftUIのWebPageViewで行う
class WebViewController: UIViewController {
    let url: URL
    let titleText: String

    init(url: URL, titleText: String) {
        self.url = url
        self.titleText = titleText
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = titleText
        view.backgroundColor = .white
        embed(WebPageView(
            title: titleText,
            url: url,
            onBack: { [weak self] in self?.navigationController?.popViewController(animated: true) }
        ))
    }
}
