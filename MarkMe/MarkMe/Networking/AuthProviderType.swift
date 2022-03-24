//
//  AuthProviderType.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 22.02.22.
//

import Foundation
import FirebaseAuth

enum AuthProviderType: String {
    case email = "password"
    case facebook = "facebook.com"
}

extension UserInfo {
    var providerType: AuthProviderType? { return AuthProviderType(rawValue: providerID)}
}

