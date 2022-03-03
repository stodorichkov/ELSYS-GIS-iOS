//
//  CreateMarkViewModel.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 28.02.22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class CreateMarkViewModel {
    let db = Firestore.firestore()
    func getMarkTypes(completion: @escaping (Result<[MarkType], AlertError>) -> ()) {
        db.collection("MarkType").getDocuments() { (querySnapshot, err) in
            guard err == nil, querySnapshot?.documents.isEmpty == false, let documents = querySnapshot?.documents else {
                completion(.failure(AlertError(title: "Database Error", message: "User is not found!")))
                return
            }
            var markTypes = [MarkType]()
            for document in documents {
                do {
                    guard let markType = try document.data(as: MarkType.self) else{
                        return
                    }
                    markTypes.append(markType)
                }
                catch {
                    print(error)
                }
            }
            completion(.success(markTypes))
        }
    }
}
