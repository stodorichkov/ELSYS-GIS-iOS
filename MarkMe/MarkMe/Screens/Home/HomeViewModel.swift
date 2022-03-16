//
//  HomeViewModel.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 7.03.22.
//

import Foundation
import FirebaseFirestore

class HomeViewModel {
    let db = Firestore.firestore()
    
    func getAllMarks(completion: @escaping (Result<[Mark], AlertError>) -> ()) {
        db.collection("Mark").addSnapshotListener { (querySnapshot, err) in
            guard err == nil, let documents = querySnapshot?.documents else {
                completion(.failure(AlertError.db("Marks are not found!")))
                return
            }
            var marks = [Mark]()
            marks = documents.compactMap { (document) -> Mark? in
                return try? document.data(as: Mark.self)
            }
            completion(.success(marks))
        }
    }
    
    func getCreatorName(documentRef: DocumentReference, completion: @escaping (String) -> ()) {
        documentRef.addSnapshotListener() { (document, err) in
            guard err == nil,
                  let document = document,
                  document.exists,
                  let data = document.data(),
                  let username = data["username"] as? String
            else {
                completion("")
                return
            }
            completion(username)
        }
    }
}
