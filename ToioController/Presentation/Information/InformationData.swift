//
//  InformationData.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/16.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import Foundation

struct InformationData {
    var label: String
    var title: String
    var type: PageType
    /// 一覧に表示するアイコン(SF Symbol名)
    var systemImage: String
    var tint: InformationTint
}

/// 一覧のアイコンの色の組み合わせ
enum InformationTint {
    case setting
    case gamepad
    case toio
    case apps
    case privacy
}

enum PageType {
    case webView(url: URL)
    case normal
    case download
}
