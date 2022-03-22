//
//  ShowMarksViewModel.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 17.03.22.
//

import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import UIKit

class ShowMarkViewModel {
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser!.uid
    
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
    
    func setImage(imgPath: String) -> StorageReference? {
        if imgPath != "" {
            let storage = Storage.storage()
            return storage.reference(forURL: imgPath)
        }
        return nil
    }
    
    func updateSet(markID: String?, arrayName: String, array: [String]) {
        guard let markID = markID else {
            return
        }
        db.collection("Mark").document(markID).updateData([arrayName: array]) { err in
            if let err = err {
                print(err.localizedDescription)
            }
        }
    }
}

