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
    }

    @IBAction func leftSlider(_ sender: UISlider) {
        leftLabel.text = String(Int(sender.value * 100)) + "%"
    }

    @IBAction func rightSlider(_ sender: UISlider) {
        rightLabel.text = String(Int(sender.value * 100)) + "%"
    }

    @IBAction func downSlider(_ sender: UISlider) {
        downLabel.text = String(Int(sender.value * 100)) + "%"
    }
}
