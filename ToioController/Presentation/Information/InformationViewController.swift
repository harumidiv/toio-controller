//
//  InformationViewController.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/15.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "information")
        }
    }

    lazy var informationData: [InformationData] = {
        [
            InformationData(label: "コントローラ設定", title: "設定", type: .normal),
            InformationData(label: "プライバシーポリシー", title: "プライバシーポリシー", type: .webView(url: URL(string: "https://harumidiv.github.io/toio-controller/")!)),
            InformationData(label: "toioについて", title: "toio", type: .webView(url: URL(string: "https://toio.io/")!))
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "情報"
    }
}

extension InformationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return informationData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "information", for: indexPath)
        cell.textLabel?.text = informationData[indexPath.row].label
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = informationData[indexPath.row]
        switch data.type {
        case .normal:
            break
        case let .webView(url):
            break
        }
    }
}
