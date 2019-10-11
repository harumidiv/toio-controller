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
            InformationData(label: R.string.localizeString.informationListControllerSetting(), title: R.string.localizeString.navigationSetting(), type: .normal),
            InformationData(label: R.string.localizeString.informationListPrivacypolicy(), title: R.string.localizeString.navigationPrivacypolicy(), type: .webView(url: URL(string: "https://harumidiv.github.io/toio-controller/")!)),
            InformationData(label: R.string.localizeString.informationListAboutToio(), title: R.string.localizeString.navigationAbountToio(), type: .webView(url: URL(string: "https://toio.io/")!))
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizeString.navigationInformation()
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
            let toVC = SettingViewController(titleText: data.title)
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(toVC, animated: true)
        case let .webView(url):
            let toVC = WebViewController(url: url, titleText: data.title)
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(toVC, animated: true)
        }
    }
}
