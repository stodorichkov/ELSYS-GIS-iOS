//
//  EditMarkViewModel.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 22.03.22.
//

import Foundation
import FirebaseFirestore

class EditMarkViewModel {
    let db = Firestore.firestore()
    var markTypes = [MarkType]()
    var mark: Mark?
    var updateData = [String: Any]()
    
    init() {
        getMarkTypes()
    }
    
    func getMarkTypes() {
        db.collection("MarkType").addSnapshotListener { [weak self] (querySnapshot, err) in
            guard err == nil, querySnapshot?.documents.isEmpty == false, let documents = querySnapshot?.documents else {
                print(err.debugDescription)
                return
            }
            self?.markTypes = documents.compactMap { try? $0.data(as: MarkType.self) }
        }
    }
    
    // check form is completed
    func isFormComplete(title: String, description: String, type: String) -> Bool {
        return !title.isEmpty && !description.isEmpty && !type.isEmpty
    }
    
    func isMarkTypevalid(type: String) -> Bool{
        return markTypes.contains(where: { $0.type == type })
    }
    
    func isDataNotChange(title: String, description: String, type: String) -> Bool {
        guard let mark = mark else {
            return true
        }

        if title != mark.title {
            updateData["title"] = title
        }
        if description != mark.description {
            updateData["description"] = description
        }
        if type != mark.type {
            updateData["type"] = type
        }
        
        return updateData.isEmpty
    }
    
    func updateMark(title: String?, description: String?, type: String?, completion: @escaping (AlertError?) -> ()) {
        guard let title = title,
              let description = description,
              let type = type,
              isFormComplete(title: title, description: description, type: type)
        else {
            completion(AlertError.validation("The form must be completed!"))
            return
        }
        
        guard isMarkTypevalid(type: type) else {
            completion(AlertError.validation("Mark type is invalid!"))
            return
        }
        
        if isDataNotChange(title: title, description: description, type: type) {
            completion(nil)
            return
        }
        
        guard let id = mark?.id else {
            return
        }
        
        db.collection("Mark").document(id).updateData(updateData) { (err) in
            if let err = err {
                completion(AlertError.db(err.localizedDescription))
            }
            else {
                completion(nil)
            }
        }
        
    }
}
