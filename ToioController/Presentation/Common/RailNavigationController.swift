//
//  RailNavigationController.swift
//  ToioController
//

import UIKit

/// 各画面はサイドレールの戻るボタンで遷移するので、ナビゲーションバーを常に隠す。
/// バーを隠すと標準ではスワイプで戻れなくなるため、ジェスチャーは自前で有効にしておく
final class RailNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(true, animated: false)
        interactivePopGestureRecognizer?.delegate = self
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // 最初の画面では戻り先がないので開始しない
        return viewControllers.count > 1
    }
}
