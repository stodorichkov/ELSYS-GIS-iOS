//
//  MarkListViewModel.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 21.03.22.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import UIKit

class MarkListViewModel {
    let db = Firestore.firestore()
    var creatorRef: DocumentReference?
    var marks = [Mark]()
    var delegate: MarkActionsDelegate?
    
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
            if let err = err {
                print(err.localizedDescription)
                return
            }
            
            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                self?.marks = []
                self?.delegate?.reloadTable()
                return
            }
            
            self?.marks = documents.compactMap { try? $0.data(as: Mark.self) }
            self?.delegate?.reloadTable()
        }
    }
    
    func deleteMark(mark: Mark?) {
        guard let mark = mark, let documentID = mark.id else {
            return
        }
        if !mark.imgPath.isEmpty {
            let storage = Storage.storage()
            let ref = storage.reference(forURL: mark.imgPath)
            
            ref.delete() { err in
                if let err = err {
                    print(err)
                }
            }
        }
    
        db.collection("Mark").document(documentID).delete() { [weak self] err in
            if let err = err {
                print(err)
                return
            }
            self?.delegate?.reloadTable()
        }
    }
}
