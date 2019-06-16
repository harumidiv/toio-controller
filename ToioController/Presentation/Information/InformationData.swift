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
}

enum PageType {
    case webView(url: URL)
    case normal
}
