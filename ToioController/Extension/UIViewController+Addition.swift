//
//  UIViewController+Addition.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/15.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import UIKit


extension UIViewController{
    func showInformation(title: String = "", message: String, buttonText: String, handler: (() -> Void)? = nil) {
        let bleAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let close: UIAlertAction = UIAlertAction(title: buttonText, style: UIAlertAction.Style.default, handler: { _ in
            bleAlert.dismiss(animated: true, completion: nil)
            handler?()
        })
        bleAlert.addAction(close)
        present(bleAlert, animated: true, completion: nil)
    }
}
