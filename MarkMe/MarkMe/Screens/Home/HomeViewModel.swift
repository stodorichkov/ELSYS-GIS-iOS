//
//  HomeViewModel.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 7.03.22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class HomeViewModel {
    let db = Firestore.firestore()
    func getAllMarks(completion: @escaping (Result<[Mark], AlertError>) -> ()) {
        db.collection("Mark").addSnapshotListener { (querySnapshot, err) in
            guard err == nil, let documents = querySnapshot?.documents else {
                completion(.failure(AlertError(title: "Database Error", message: "Marks are not found!")))
                return
            }
            var marks = [Mark]()
            for document in documents {
                do {
                    guard let mark = try document.data(as: Mark.self) else{
                        return
                    }
                    marks.append(mark)
                }
                catch {
                    print(error)
                }
            }
            completion(.success(marks))
        }
    }
}
