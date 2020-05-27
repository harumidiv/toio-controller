//
//  String+Addition.swift
//  ToioController
//
//  Created by 佐川 晴海 on 2020/05/24.
//  Copyright © 2020 佐川晴海. All rights reserved.
//

import Foundation

extension String {
    func hexStringtoAscii() -> String {
        let pattern = "(0x)?([0-9a-f]{2})"
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let nsString = self as NSString
        let range = NSRange(location: 0, length: nsString.length)
        let matches = regex.matches(in: self, options: [], range: range)
        let characters = matches.map {
            Character(UnicodeScalar(UInt32(nsString.substring(with: $0.range(at: 2)), radix: 16)!)!)
        }
        return String(characters)
    }
}
