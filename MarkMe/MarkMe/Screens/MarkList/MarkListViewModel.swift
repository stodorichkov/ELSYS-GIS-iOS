//
//  MarkListViewModel.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 21.03.22.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import UIKit

class MarkListViewModel {
    let db = Firestore.firestore()
    var creatorRef: DocumentReference!
    var marks = [Mark]()
    var delegate: CustomTableDelegate?
    
    init() {
        getCreator()
        getMarks()
    }
    
    func getCreator() {
        guard let curUser = Auth.auth().currentUser else{
            return
        }
        self.creatorRef = db.collection("User").document(curUser.uid)
    }
    
    func getMarks() {
        guard let creatorRef = creatorRef else {
            return
        }
        db.collection("Mark").whereField("creator", isEqualTo: creatorRef).addSnapshotListener { [weak self] (querySnapshot, err) in
            guard err == nil, querySnapshot?.documents.isEmpty == false, let documents = querySnapshot?.documents else {
                print(err.debugDescription)
                return
            }
            self?.marks = documents.compactMap { (document) -> Mark? in
                return try? document.data(as: Mark.self)
            }
            self?.delegate?.reloadTable()
        }
    }
}
