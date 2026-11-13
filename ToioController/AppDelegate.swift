//
//  AppDelegate.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/14.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // DI
        OtherInjector.register()
        ConnectInjector.register()

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(appColor: .theme)
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().tintColor = .white
        return true
    }

    // MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let configuration = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        configuration.delegateClass = SceneDelegate.self
        return configuration
    }
}

// MARK: - SceneDelegate

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }
        let window = UIWindow(windowScene: windowScene)
        let navigationController = RailNavigationController(rootViewController: ConnectViewController())
        #if DEBUG
            openScreenshotScreen(in: navigationController)
        #endif
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }

    #if DEBUG
        /// App Store用のスクリーンショット撮影で、cubeに接続しなくても各画面を開けるようにする(DEBUGビルドのみ)
        /// 例: 起動引数に `-screenshotScreen control` / `-screenshotScreen setting` を指定する
        private func openScreenshotScreen(in navigationController: UINavigationController) {
            switch UserDefaults.standard.string(forKey: "screenshotScreen") {
            case "control":
                navigationController.pushViewController(ControlViewController(cubeModel: nil), animated: false)
            case "setting":
                navigationController.pushViewController(InformationViewController(), animated: false)
                navigationController.pushViewController(SettingViewController(titleText: R.string.localizeString.navigationSetting()), animated: false)
            default:
                break
            }
        }
    #endif
}
