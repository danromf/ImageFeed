//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Даниил Романов on 01.07.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private let tokenKey = "OAuth2Token"
    
    private init() {}
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            guard let newValue else {
                KeychainWrapper.standard.removeObject(forKey: tokenKey)
                return
            }
            
            KeychainWrapper.standard.set(newValue, forKey: tokenKey)
        }
    }
}
