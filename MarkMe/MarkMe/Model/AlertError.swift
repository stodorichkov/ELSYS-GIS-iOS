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
