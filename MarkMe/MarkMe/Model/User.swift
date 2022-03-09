//
//  User.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 26.02.22.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable, Identifiable {
    @DocumentID var id: String?
    var uid: String = ""
    var username: String = ""
    var email: String = ""
    var password: String = ""
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    init(username: String, email: String, password: String) {
        self.username = username
        self.email = email
        self.password = password
    }
    
    
    enum CodingKeys: String, CodingKey {
        case username
        case uid
        case email
    }
}

