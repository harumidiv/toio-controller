//
//  SettingViewController.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/16.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import StoreKit
import SwiftUI
import UIKit

/// 設定画面。表示はSwiftUIのSettingViewで行い、ここでは保存とレビュー依頼を扱う
class SettingViewController: UIViewController {
    let titleText: String

    init(titleText: String) {
        self.titleText = titleText
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        openAppReviewWindow()
        title = titleText
        view.backgroundColor = .white
        embed(SettingView(
            title: titleText,
            speed: SpeedSetting(up: UserStore.up, down: UserStore.down, left: UserStore.left, right: UserStore.right),
            onBack: { [weak self] in self?.navigationController?.popViewController(animated: true) },
            onSave: { [weak self] speed in self?.save(speed) }
        ))
    }

    private func openAppReviewWindow() {
        guard !UserStore.appReview else { return }
        if #available(iOS 16, *), let scene = view.window?.windowScene {
            AppStore.requestReview(in: scene)
        }
        UserStore.appReview = true
    }

    // MARK: - Event

    private func save(_ speed: SpeedSetting) {
        UserStore.up = speed.up
        UserStore.down = speed.down
        UserStore.left = speed.left
        UserStore.right = speed.right

        let saveAlert = UIAlertController(title: R.string.localizeString.settingDialogSave(), message: "", preferredStyle: UIAlertController.Style.alert)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            saveAlert.dismiss(animated: true, completion: nil)
        })
        present(saveAlert, animated: true, completion: nil)
    }
}
