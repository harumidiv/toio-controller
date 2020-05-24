//
//  FirmwareVersion.swift
//  ToioController
//
//  Created by 佐川 晴海 on 2020/05/24.
//  Copyright © 2020 佐川晴海. All rights reserved.
//

import Foundation

struct FirmwareVersion: Equatable {
    let major: Int
    let minor: Int
    var patch: Int?
    var text: String {
        return "v\(major).\(minor)"
    }

    var analyticsLogText: String {
        if let patch = patch {
            return "\(major).\(minor).\(patch)"
        }
        return "\(major).\(minor)"
    }

    init(major: Int, minor: Int, patch: Int?) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }

    init(version: String) {
        var split: [String] = version.components(separatedBy: ".")

        #if Release
            if split.count != 3 {
                major = 0
                minor = 0
                patch = 0
                return
            }
        #else
            // TODO: Specification of cube version is changed <major>.<minor>.<patch>.d
        #endif

        guard let major = Int(split[0]), let minor = Int(split[1]), let patch = Int(split[2]) else {
            self.major = 0
            self.minor = 0
            self.patch = 0
            return
        }
        self.major = major
        self.minor = minor
        self.patch = patch
    }

    static func == (lhs: FirmwareVersion, rhs: FirmwareVersion) -> Bool {
        return lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.patch == rhs.patch
    }
}

extension FirmwareVersion: Codable {}
