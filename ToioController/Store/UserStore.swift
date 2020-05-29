//
//  UserStore.swift
//  ToioController
//
//  Created by 佐川 晴海 on 2020/05/29.
//  Copyright © 2020 佐川晴海. All rights reserved.
//

import Foundation

final class UserStore {
    private enum Key: String {
        case appReview
        case up
        case down
        case left
        case right
    }

    // アプリのレビューが表示されたかどうか（一度表示されたユーザには再度表示は行わない）
    static var appReview: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: Key.appReview.rawValue)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: Key.appReview.rawValue)
        }
    }
    
    // toioの操作スピード
    static var up: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: Key.up.rawValue)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.integer(forKey: Key.up.rawValue)
        }
    }
    static var down: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: Key.down.rawValue)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.integer(forKey: Key.down.rawValue)
        }
    }
    static var left: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: Key.left.rawValue)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.integer(forKey: Key.left.rawValue)
        }
    }
    static var right: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: Key.right.rawValue)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.integer(forKey: Key.right.rawValue)
        }
    }
}
