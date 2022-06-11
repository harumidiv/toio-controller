//
//  SettingViewController.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/16.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import StoreKit
import UIKit

class SettingViewController: UIViewController {
    @IBOutlet weak var informationLabel: UILabel! {
        didSet {
            informationLabel.text = R.string.localizeString.settingDescription()
        }
    }

    let titleText: String

    lazy var upValue: Int = UserStore.up

    lazy var leftValue: Int = UserStore.left

    lazy var rightValue: Int = UserStore.right

    lazy var downValue: Int = UserStore.down

    // Slider
    @IBOutlet weak var upSlider: UISlider! {
        didSet {
            upSlider.value = Float(UserStore.up) / 100
        }
    }

    @IBOutlet weak var leftSlider: UISlider! {
        didSet {
            leftSlider.value = Float(UserStore.left) / 100
        }
    }

    @IBOutlet weak var rightSlider: UISlider! {
        didSet {
            rightSlider.value = Float(UserStore.right) / 100
        }
    }

    @IBOutlet weak var downSlider: UISlider! {
        didSet {
            downSlider.value = Float(UserStore.down) / 100
        }
    }

    @IBOutlet weak var upLabel: UILabel! {
        didSet {
            upLabel.text = UserStore.up.description
        }
    }

    @IBOutlet weak var leftLabel: UILabel! {
        didSet {
            leftLabel.text = UserStore.left.description
        }
    }

    @IBOutlet weak var rightLabel: UILabel! {
        didSet {
            rightLabel.text = UserStore.right.description
        }
    }

    @IBOutlet weak var downLabel: UILabel! {
        didSet {
            downLabel.text = UserStore.down.description
        }
    }

    @IBOutlet weak var saveButton: SearchButton! {
        didSet {
            saveButton.setTitle(R.string.localizeString.settingButtonTitle(), for: .normal)
        }
    }

    init(titleText: String) {
        self.titleText = titleText
        super.init(nibName: String(describing: SettingViewController.self), bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        openAppReviewWindow()
        title = titleText
    }

    private func openAppReviewWindow() {
        if !UserStore.appReview {
            SKStoreReviewController.requestReview()
            UserStore.appReview = true
        }
    }

    // MARK: - Event

    @IBAction func upSlider(_ sender: UISlider) {
        upLabel.text = String(Int(sender.value * 100)) + "%"
        upValue = Int(sender.value * 100)
    }

    @IBAction func leftSlider(_ sender: UISlider) {
        leftLabel.text = String(Int(sender.value * 100)) + "%"
        leftValue = Int(sender.value * 100)
    }

    @IBAction func rightSlider(_ sender: UISlider) {
        rightLabel.text = String(Int(sender.value * 100)) + "%"
        rightValue = Int(sender.value * 100)
    }

    @IBAction func downSlider(_ sender: UISlider) {
        downLabel.text = String(Int(sender.value * 100)) + "%"
        downValue = Int(sender.value * 100)
    }

    @IBAction func saveTaped(_ sender: Any) {
        UserStore.up = upValue
        UserStore.down = downValue
        UserStore.left = leftValue
        UserStore.right = rightValue

        let saveAlert = UIAlertController(title: R.string.localizeString.settingDialogSave(), message: "", preferredStyle: UIAlertController.Style.alert)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            saveAlert.dismiss(animated: true, completion: nil)
        })
        present(saveAlert, animated: true, completion: nil)
    }
}
