//
//  File.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 26.02.22.
//

import Foundation

enum AlertError: Error {
    case db(String)
    case storage(String)
    case validation(String)
    case address(String)
    case registration(String)
    case login(String)
    case logout(String)
    case facebook(String)
    case delete(String)
    case forgotPassword(String)
}

extension AlertError {
    var title: String {
        switch self {
        case .db(_):
            return "Database Error"
        case .storage(_):
            return "Storage Error"
        case .validation(_):
            return "Validation Error"
        case .address(_):
            return "Address Error"
        case .registration(_):
            return "Regsitration Error"
        case .login(_):
            return "Login Error"
        case .logout(_):
            return "Logout Error"
        case .facebook(_):
            return "Facebook Error"
        case .delete(_):
            return "Delete Error"
        case .forgotPassword(_):
            return "Forgot Password Error"
        }
    }
    
    var errorDescription: String {
        switch self {
        case .db(let message):
            return message
        case .storage(let message):
            return message
        case .validation(let message):
            return message
        case .address(let message):
            return message
        case .registration(let message):
            return message
        case .login(let message):
            return message
        case .logout(let message):
            return message
        case .facebook(let message):
            return message
        case .delete(let message):
            return message
        case .forgotPassword(let message):
            return message
        }
    }
}


