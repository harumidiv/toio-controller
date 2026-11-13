//
//  InformationViewController.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/15.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import SwiftUI
import UIKit

/// 情報画面。表示はSwiftUIのInformationViewで行い、ここでは画面遷移を扱う
class InformationViewController: UIViewController {
    /// toio アップデートアプリのApp Store
    private static let toioUpdateAppURL = URL(string: "https://itunes.apple.com/app/id1455128254?")!

    lazy var informationData: [InformationData] = [
        InformationData(label: R.string.localizeString.informationListControllerSetting(),
                        title: R.string.localizeString.navigationSetting(),
                        type: .normal,
                        systemImage: "slider.horizontal.3", tint: .setting),
        InformationData(label: R.string.localizeString.informationListAbountDualshock(),
                        title: "dualshock4",
                        type: .webView(url: URL(string: "https://www.jp.playstation.com/accessories/dualshock4/")!),
                        systemImage: "gamecontroller", tint: .gamepad),
        InformationData(label: R.string.localizeString.informationListAboutToio(),
                        title: R.string.localizeString.navigationAbountToio(),
                        type: .webView(url: URL(string: "https://toio.io/")!),
                        systemImage: "cube", tint: .toio),
        InformationData(label: R.string.localizeString.informationListRelatedApps(),
                        title: R.string.localizeString.informationListRelatedApps(),
                        type: .webView(url: URL(string: "https://harumidiv.github.io/AppleStoreDevelopprSite/#apps")!),
                        systemImage: "square.grid.2x2", tint: .apps),
        InformationData(label: R.string.localizeString.informationListPrivacypolicy(),
                        title: R.string.localizeString.navigationPrivacypolicy(),
                        type: .webView(url: URL(string: "https://harumidiv.github.io/toio-controller/")!),
                        systemImage: "hand.raised", tint: .privacy),
        InformationData(label: R.string.localizeString.informationListToioUpdateMessage(),
                        title: R.string.localizeString.informationListToioUpdateTitle(),
                        type: .download,
                        systemImage: "arrow.down.circle", tint: .toio),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizeString.navigationInformation()
        view.backgroundColor = .white
        embed(InformationView(
            items: informationData,
            onBack: { [weak self] in self?.navigationController?.popViewController(animated: true) },
            onSelect: { [weak self] item in self?.select(item) },
            onDownload: { UIApplication.shared.open(InformationViewController.toioUpdateAppURL) }
        ))
    }

    private func select(_ data: InformationData) {
        switch data.type {
        case .normal:
            navigationController?.pushViewController(SettingViewController(titleText: data.title), animated: true)
        case let .webView(url):
            navigationController?.pushViewController(WebViewController(url: url, titleText: data.title), animated: true)
        case .download:
            UIApplication.shared.open(InformationViewController.toioUpdateAppURL)
        }
    }
}
