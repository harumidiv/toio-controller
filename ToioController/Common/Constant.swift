//
//  Constant.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/15.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import Foundation

struct Constant {
    // MARK: - CharacteristicUUID

    struct CharacteristicUUID {
        static let motorControll = "10B20102-5B3B-4571-9508-CF3EFCD7BBAE".uppercased()
        static let lightControll = "10B20103-5B3B-4571-9508-CF3EFCD7BBAE".uppercased()
        static let soundControll = "10B20104-5B3B-4571-9508-CF3EFCD7BBAE".uppercased()
    }

    struct WriteData {
        static let moterStop = Data([0x01, 0x01, 0x02, 0x00, 0x02, 0x02, 0x00])
        static let up = Data([0x01, 0x01, 0x01, 0x40, 0x02, 0x01, 0x40])
        static let down = Data([0x01, 0x01, 0x02, 0x40, 0x02, 0x02, 0x40])
        static let left = Data([0x01, 0x01, 0x01, 0x00, 0x02, 0x01, 0x40])
        static let right = Data([0x01, 0x01, 0x01, 0x40, 0x02, 0x01, 0x05])
        static let hone = Data([0x03, 0x00, 0x01, 0xFF, 0x14, 0xFF])
        static let rotate = Data([0x01, 0x01, 0x01, 0x64, 0x02, 0x02, 0x64])
    }

    struct BackData {
        static let sound = Data([0x03, 0x00, 0x03, 0x3F, 0x40, 0x7F, 0x3F, 0xFF, 0x1E, 0x01, 0xFF, 0x7F])
        static let moter = Data([0x01, 0x01, 0x02, 0x20, 0x02, 0x02, 0x20])
        static let light = Data([0x03, 0x00, 0x01, 0x01, 0xFF, 0x00, 0x00])
    }
}
