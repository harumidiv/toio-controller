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
    let userDefault = UserDefaults.standard

    lazy var upValue: Int = {
        let value: Int
        if userDefault.object(forKey: "up") != nil {
            value = userDefault.integer(forKey: "up")
        } else {
            value = 60
        }
        return value
    }()

    lazy var leftValue: Int = {
        let value: Int
        if userDefault.object(forKey: "left") != nil {
            value = userDefault.integer(forKey: "left")
        } else {
            value = 60
        }
        return value
    }()

    lazy var rightValue: Int = {
        let value: Int
        if userDefault.object(forKey: "right") != nil {
            value = userDefault.integer(forKey: "right")
        } else {
            value = 60
        }
        return value
    }()

    lazy var downValue: Int = {
        let value: Int
        if userDefault.object(forKey: "down") != nil {
            value = userDefault.integer(forKey: "down")
        } else {
            value = 60
        }
        return value
    }()

    @IBOutlet weak var upSlider: UISlider! {
        didSet {
            let value: Int
            if userDefault.object(forKey: "up") != nil {
                value = userDefault.integer(forKey: "up")
            } else {
                value = 60
            }
            upSlider.value = Float(value) / 100
        }
    }

    @IBOutlet weak var leftSlider: UISlider! {
        didSet {
            let value: Int
            if userDefault.object(forKey: "left") != nil {
                value = userDefault.integer(forKey: "left")
            } else {
                value = 60
            }
            leftSlider.value = Float(value) / 100
        }
    }

    @IBOutlet weak var rightSlider: UISlider! {
        didSet {
            let value: Int
            if userDefault.object(forKey: "right") != nil {
                value = userDefault.integer(forKey: "right")
            } else {
                value = 60
            }
            rightSlider.value = Float(value) / 100
        }
    }

    @IBOutlet weak var downSlider: UISlider! {
        didSet {
            let value: Int
            if userDefault.object(forKey: "down") != nil {
                value = userDefault.integer(forKey: "down")
            } else {
                value = 60
            }
            downSlider.value = Float(value) / 100
        }
    }

    @IBOutlet weak var upLabel: UILabel! {
        didSet {
            let value: Int
            if userDefault.object(forKey: "up") != nil {
                value = userDefault.integer(forKey: "up")
            } else {
                value = 60
            }
            upLabel.text = value.description
        }
    }

    @IBOutlet weak var leftLabel: UILabel! {
        didSet {
            let value: Int
            if userDefault.object(forKey: "left") != nil {
                value = userDefault.integer(forKey: "left")
            } else {
                value = 60
            }
            leftLabel.text = value.description
        }
    }

    @IBOutlet weak var rightLabel: UILabel! {
        didSet {
            let value: Int
            if userDefault.object(forKey: "right") != nil {
                value = userDefault.integer(forKey: "right")
            } else {
                value = 60
            }
            rightLabel.text = value.description
        }
    }

    @IBOutlet weak var downLabel: UILabel! {
        didSet {
            let value: Int
            if userDefault.object(forKey: "down") != nil {
                value = userDefault.integer(forKey: "down")
            } else {
                value = 60
            }
            downLabel.text = value.description
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
        userDefault.set(upValue, forKey: "up")
        userDefault.set(downValue, forKey: "down")
        userDefault.set(leftValue, forKey: "left")
        userDefault.set(rightValue, forKey: "right")
        userDefault.synchronize()
        let saveAlert = UIAlertController(title: R.string.localizeString.settingDialogSave(), message: "", preferredStyle: UIAlertController.Style.alert)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            saveAlert.dismiss(animated: true, completion: nil)
        })
        present(saveAlert, animated: true, completion: nil)
    }
}
