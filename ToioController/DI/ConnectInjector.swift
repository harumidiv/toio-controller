//
//  ConnectInjector.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/15.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import Swinject

final class ConnectInjector: Injector {
    static let container = Container()

    static func register() {
        container.register(ConnectPresenter.self) { _, output in
            ConnectPresenterImpl(output: output)
        }
        container.register(ConnectUseCase.self) { _ in
            ConnectUseCaseImpl()
        }
        container.register(ConnectWireframe.self) { _ in
            ConnectWireframeImpl()
        }
        #if DEVELOP
            container.register(ConnectPresenter.self) { _, output in
                ConnectMockPresenterImpl(output: output)
            }
        #endif

        #if MOCK
            container.register(ConnectPresenter.self) { _, output in
                ConnectMockPresenterImpl(output: output)
            }
        #endif
    }
}
