//
//  InformationViewController.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/15.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import Rswift
import StoreKit
import UIKit

class InformationViewController: UIViewController, SKStoreProductViewControllerDelegate {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "information")
            tableView.register(R.nib.storeDownloadCell)
        }
    }

    lazy var informationData: [InformationData] = {
        [
            InformationData(label: R.string.localizeString.informationListControllerSetting(), title: R.string.localizeString.navigationSetting(), type: .normal),
            InformationData(label: R.string.localizeString.informationListPrivacypolicy(), title: R.string.localizeString.navigationPrivacypolicy(), type: .webView(url: URL(string: "https://harumidiv.github.io/toio-controller/")!)),
            InformationData(label: R.string.localizeString.informationListAboutToio(), title: R.string.localizeString.navigationAbountToio(), type: .webView(url: URL(string: "https://toio.io/")!)),
            InformationData(label: R.string.localizeString.imformationListAbountDualshock(), title: "dualshock4", type: .webView(url: URL(string: "https://www.jp.playstation.com/accessories/dualshock4/")!)),
            InformationData(label: "toio コンソール/toio コア キューブのソフトウェアをアップデートして頂くことにより、toioに新しい機能が追加されたり、安定性が向上します。",
                            title: "toio アップデートアプリ",
                            type: .download)
        ]
    }()

    private var isNotStoreOpen: Bool = true

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
        let data = informationData[indexPath.row]
        switch data.type {
        case .download:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.storeDownloadCell, for: indexPath)!
            cell.setup(title: data.title, description: data.label, buttonAction: { () -> Void in

                guard let url = URL(string: "https://itunes.apple.com/app/id1455128254?") else {
                    return
                }
                UIApplication.shared.open(url)
            })
            cell.selectionStyle = .none
            return cell

        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "information", for: indexPath)
            cell.textLabel?.text = informationData[indexPath.row].label

            return cell
        }
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
        case .download:
            // NOP:
            break
        }
    }

    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        isNotStoreOpen = true
    }
}
