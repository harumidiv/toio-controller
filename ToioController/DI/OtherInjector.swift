//
//  OtherInjector.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/15.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import Swinject

class OtherInjector: Injector {
    static let container = Container()
    static func register() {
        container.register(PhoneDeviceUsecase.self) { _ in
            PhoneDeviceUsecaseImpl()
        }
    }
}
