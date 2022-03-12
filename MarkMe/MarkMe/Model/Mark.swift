//
//  Mark.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 6.03.22.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct Mark: Codable, Identifiable  {
    @DocumentID var id: String?
    var title: String
    var description: String
    var geolocation: GeoPoint
    var imgPath: String = ""
    var type: String
    var creator: DocumentReference
    var likes: Int = 0
    var solved: Int = 0
}
