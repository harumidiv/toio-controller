//
//  ConnectWireframe.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/15.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import UIKit

protocol ConnectWireframe: AnyObject {
    func showInformation(vc: UIViewController)
    func showController(vc: UIViewController, model: CubeModel?)
}

class ConnectWireframeImpl: ConnectWireframe {
    func showInformation(vc: UIViewController) {
        let toVC = InformationViewController()
        vc.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        vc.navigationController?.pushViewController(toVC, animated: true)
    }

    func showController(vc: UIViewController, model: CubeModel?) {
        let toVC = ControlViewController(cubeModel: model)
        vc.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        vc.navigationController?.pushViewController(toVC, animated: true)
    }
}
