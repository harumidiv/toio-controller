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
}

protocol ConnectPresenterOutput: AnyObject {
    func showBatteryError()
    func showBluetoothError()
    func showDevice()
}

class ConnectPresenterImpl: ConnectPresenter {
    private let phoneDeviceUseCase: PhoneDeviceUsecase = OtherInjector.container.resolve(PhoneDeviceUsecase.self)!

    private weak var output: ConnectPresenterOutput?

    init(output: ConnectPresenterOutput) {
        self.output = output
    }

    // MAKR: - Public methods
    func checkPhoneState() {
        phoneDeviceUseCase.getBattery()
            .take(1)
            .observeOn(MainScheduler.instance)
            .flatMap { [weak self] (battery) -> Observable<BluetoothState> in
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
                default:
                    self.output?.showBluetoothError()
                }
            })
    }

    func loadDevice() {}
}
