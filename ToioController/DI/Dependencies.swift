//
//  Dependencies.swift
//  ToioController
//

import Foundation

/// Presenter・UseCase・Wireframeの生成をまとめる。
/// Develop/Mockビルドでは、cubeが無くても画面を確認できるMockに差し替える
enum Dependencies {
    static func makeConnectPresenter(output: ConnectPresenterOutput) -> ConnectPresenter {
        #if DEVELOP || MOCK
            return ConnectMockPresenterImpl(output: output)
        #else
            return ConnectPresenterImpl(output: output)
        #endif
    }

    static func makeConnectUseCase() -> ConnectUseCase {
        return ConnectUseCaseImpl()
    }

    static func makeConnectWireframe() -> ConnectWireframe {
        return ConnectWireframeImpl()
    }

    static func makePhoneDeviceUsecase() -> PhoneDeviceUsecase {
        return PhoneDeviceUsecaseImpl()
    }
}
