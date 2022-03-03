//
//  MarkType.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 28.02.22.
//

import Foundation
import FirebaseFirestoreSwift

struct MarkType: Codable {
    @DocumentID var id: String?
    var type: String
}

