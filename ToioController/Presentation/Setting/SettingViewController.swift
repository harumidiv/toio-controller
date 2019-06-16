//
//  SettingViewController.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/16.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
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
        if userDefault.object(forKey: "up") != nil {
            value = userDefault.integer(forKey: "left")
        } else {
            value = 60
        }
        return value
    }()

    lazy var rightValue: Int = {
        let value: Int
        if userDefault.object(forKey: "up") != nil {
            value = userDefault.integer(forKey: "right")
        } else {
            value = 60
        }
        return value
    }()

    lazy var downValue: Int = {
        let value: Int
        if userDefault.object(forKey: "up") != nil {
            value = userDefault.integer(forKey: "down")
        } else {
            value = 60
        }
        return value
    }()

    @IBOutlet weak var upLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var downLabel: UILabel!
    @IBOutlet weak var saveButton: SearchButton! {
        didSet {
            saveButton.setTitle("設定を保存する", for: .normal)
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

        title = titleText
    }

    // MARK: - Event

    @IBAction func upSlider(_ sender: UISlider) {
        upLabel.text = String(Int(sender.value * 100)) + "%"
        upValue = Int(sender.value * 64)
    }

    @IBAction func leftSlider(_ sender: UISlider) {
        leftLabel.text = String(Int(sender.value * 100)) + "%"
        leftValue = Int(sender.value * 64)
    }

    @IBAction func rightSlider(_ sender: UISlider) {
        rightLabel.text = String(Int(sender.value * 100)) + "%"
        rightValue = Int(sender.value * 64)
    }

    @IBAction func downSlider(_ sender: UISlider) {
        downLabel.text = String(Int(sender.value * 100)) + "%"
        downValue = Int(sender.value * 64)
    }

    @IBAction func saveTaped(_ sender: Any) {
        userDefault.set(upValue, forKey: "up")
        userDefault.set(downValue, forKey: "down")
        userDefault.set(leftValue, forKey: "left")
        userDefault.set(rightValue, forKey: "right")
    }
}
