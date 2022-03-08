//
//  File.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 26.02.22.
//

import Foundation

struct AlertError: Error {
    var title: String
    var message: String
    
    init(title: String, message: String) {
        self.title = title
        self.message = message
    }
}

enum ErrorTitle: String {
    case db = "Database Error"
    case storage = "Storage Error"
    case validation = "Validation Error"
    case address = "Address Error"
    case registration = "Regsitration Error"
    case login = "Login Error"
    case logout = "Logout Error"
    case facebook = "Facebook Error"
    
}
