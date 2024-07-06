//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Даниил Романов on 01.07.2024.
//

import Foundation

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private let userDefaults = UserDefaults.standard
    private let tokenKey = "OAuth2Token"
    
    private init() {}
    
    var token: String? {
        get {
            return userDefaults.string(forKey: tokenKey)
        }
        set {
            userDefaults.setValue(newValue, forKey: tokenKey)
        }
    }
}
