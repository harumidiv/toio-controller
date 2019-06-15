//
//  ConnectPresenter.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/15.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import Foundation
import RxSwift

protocol ConnectPresenter: AnyObject {
    func checkPhoneState()
    func loadDevice()
}

protocol ConnectPresenterOutput: AnyObject {}

class ConnectPresenterImpl: ConnectPresenter {
    func checkPhoneState() {}

    func loadDevice() {}
}
