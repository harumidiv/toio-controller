//
//  Dualshock.swift
//  ToioController
//
//  Created by しじみ100% on 2019/09/20.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import Foundation
import GameController

class Dualshock {
    init() {
        setupGameController()
    }

    private func setupGameController() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(handleControllerDidConnect),
            name: NSNotification.Name.GCControllerDidConnect, object: nil
        )

        NotificationCenter.default.addObserver(
            self, selector: #selector(handleControllerDidDisconnect),
            name: NSNotification.Name.GCControllerDidDisconnect, object: nil
        )
        let controllers: [GCController] = GCController.controllers()

        guard let controller: GCController = controllers.first else {
            return
        }
        registerGameController(controller)
    }

    // アプリ起動中に新規でコントローラが接続された際に飛んでくる
    @objc func handleControllerDidConnect(_ notification: Notification) {
        guard let gameController = notification.object as? GCController else {
            return
        }

        registerGameController(gameController)
    }

    // アプリ起動中にコントローラとの接続が切れると呼ばれる
    @objc func handleControllerDidDisconnect(_ notification: Notification) {
        guard let gameController = notification.object as? GCController else {
            return
        }

        unregisterGameController()

        for controller: GCController in GCController.controllers() where gameController != controller {
            registerGameController(controller)
        }
    }

    func registerGameController(_ gameController: GCController) {}

    func unregisterGameController() {
        // TODO: Controllerがdisconnectされた時にAlertを表示する
        print("disconnect")
    }
}
