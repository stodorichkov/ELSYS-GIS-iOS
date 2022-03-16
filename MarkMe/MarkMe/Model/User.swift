//
//  User.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 26.02.22.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseAuth

struct DBUser: Codable, Identifiable {
    @DocumentID var id: String?
    var username: String = ""
    var email: String
    var password: String = ""
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
        self.email = ""
    }
    
    init(username: String, password: String, email: String) {
        self.init(username: username, password: password)
        self.email = email
    }
    
    
    enum CodingKeys: String, CodingKey {
        case username
        case email
    }
}

