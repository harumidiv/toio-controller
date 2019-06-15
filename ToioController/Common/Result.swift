//
//  Result.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/15.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import UIKit

enum Result<T, E> {
    case success(T)
    case error(E)
}
