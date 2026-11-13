//
//  UIViewController+Addition.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/15.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import SwiftUI
import UIKit

extension UIViewController {
    var className: String {
        return String(describing: type(of: self))
    }

    func showInformation(title: String = "", message: String, buttonText: String, handler: (() -> Void)? = nil) {
        let bleAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let close = UIAlertAction(title: buttonText, style: UIAlertAction.Style.default, handler: { _ in
            bleAlert.dismiss(animated: true, completion: nil)
            handler?()
        })
        bleAlert.addAction(close)
        present(bleAlert, animated: true, completion: nil)
    }
}

extension UIViewController {
    /// SwiftUIの画面を子ViewControllerとして画面いっぱいに配置する
    @discardableResult
    func embed<Content: View>(_ rootView: Content) -> UIHostingController<Content> {
        let hostingController = UIHostingController(rootView: rootView)
        hostingController.view.backgroundColor = .clear
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        hostingController.didMove(toParent: self)
        return hostingController
    }
}
