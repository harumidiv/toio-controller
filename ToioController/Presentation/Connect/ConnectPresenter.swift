//
//  ConnectPresenter.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/15.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import RxBluetoothKit
import RxSwift

protocol ConnectPresenter: AnyObject {
    func checkPhoneState()
    func loadDevice()
    func checkBluetoothAuthorization() -> Bool
}

protocol ConnectPresenterOutput: AnyObject {
    func showBatteryError()
    func showBluetoothError()
    func showController(cube: CubeModel?)
    func showBluetoothPermissionAlert()
    func showDevice()
    func showTimeout()
    func showErrorDialog()
}

class ConnectPresenterImpl: ConnectPresenter {
    private let phoneDeviceUseCase: PhoneDeviceUsecase = OtherInjector.container.resolve(PhoneDeviceUsecase.self)!

    private lazy var usecase: ConnectUseCase = ConnectInjector.container.resolve(ConnectUseCase.self)!

    private weak var output: ConnectPresenterOutput?
    private let disposeBag = DisposeBag()

    init(output: ConnectPresenterOutput) {
        self.output = output
        subscribeTargetDevice()
    }

    // MAKR: - Public methods

    func checkBluetoothAuthorization() -> Bool {
        return phoneDeviceUseCase.checkBluetoothAuthorization()
    }

    func checkPhoneState() {
        phoneDeviceUseCase.getBattery()
            .take(1)
            .observeOn(MainScheduler.instance)
            .flatMap { [weak self] battery -> Observable<BluetoothState> in
                guard let self = self else {
                    return Observable.empty()
                }
                if battery < 0.2 {
                    self.output?.showBatteryError()
                    return Observable.empty()
                }
                return self.phoneDeviceUseCase.getBluetoothState()
            }
            .subscribe(onNext: { [weak self] state in
                guard let self = self else {
                    return
                }
                switch state {
                case .poweredOn:
                    self.output?.showDevice()
                case .unauthorized:
                    self.output?.showBluetoothPermissionAlert()
                default:
                    self.output?.showBluetoothError()
                }
            }).disposed(by: disposeBag)
    }

    func loadDevice() {
        usecase.loadDevice()
    }

    private func subscribeTargetDevice() {
        usecase.targetDevice.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] result in
            guard let self = self else {
                return
            }
            self.usecase.loadStop()
            switch result {
            case let .success(model):
                self.output?.showController(cube: model)
            case let .error(e):
                if e.type == .scanTimeout {
                    self.output?.showTimeout()
                } else {
                    self.output?.showErrorDialog()
                }
            }
        }).disposed(by: disposeBag)
    }
}
