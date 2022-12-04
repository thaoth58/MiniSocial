//
//  UserDefaults+Ext.swift
//  MiniSocial
//
//  Created by Thao Truong on 20/11/2022.
//

import Foundation

class UserDefaultsManager {
    private static let uidKey = "UID"

    static var userId: String? {
        get {
            UserDefaults.standard.string(forKey: uidKey)
        }

        set {
            UserDefaults.standard.set(newValue, forKey: uidKey)
        }
    }

    static var isLoggedIn: Bool {
        guard let userId = userId else { return false }

        return !userId.isEmpty
    }
}
