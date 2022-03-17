//
//  ShowMarksViewModel.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 17.03.22.
//

import FirebaseFirestore
import FirebaseStorage
import UIKit

class ShowMarkViewModel {
    let db = Firestore.firestore()
    
    func getMarkInfo(markID: String? ,completion: @escaping (Mark?) -> ()) {
        guard let markID = markID else {
            return
        }
        db.collection("Mark").document(markID).addSnapshotListener { (document, err) in
            guard err == nil, let document = document, document.exists else {
                completion(nil)
                return
            }
            do {
                let mark = try document.data(as: Mark.self)!
                completion(mark)
            }
            catch {
                print(error)
            }
        }
    }
    
    func getCreatorName(creator: DocumentReference, completion: @escaping (String) -> ()) {
        creator.addSnapshotListener() { (document, err) in
            guard err == nil,
                  let document = document,
                  document.exists,
                  let data = document.data(),
                  let username = data["username"] as? String
            else {
                completion("by")
                return
            }
            completion("by " + username)
        }
    }
}

