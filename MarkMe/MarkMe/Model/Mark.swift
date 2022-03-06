//
//  Mark.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 6.03.22.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct Mark: Codable {
    @DocumentID var id: String? = UUID().uuidString
    var title: String
    var description: String
    var geolocation: GeoPoint
    var imgPath: String = ""
    var type: String
    var creator: String
    var likes: Int = 0
    var solved: Int = 0
}
