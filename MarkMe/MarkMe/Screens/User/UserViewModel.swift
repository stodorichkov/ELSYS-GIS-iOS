//
//  UserViewModel.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 24.02.22.
//

import Foundation
import FirebaseAuth
import FacebookLogin
import FirebaseFirestore

class UserViewModel {
    let db = Firestore.firestore()
    
    func signOut(completion: (AlertError?) -> ()) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        }
        catch let error {
            completion(AlertError.logout(error.localizedDescription))
        }
    }
    
    func deleteUser() async throws {
        guard let curUser = Auth.auth().currentUser else {
            return
        }
        do {
            try await db.collection("User").document(curUser.uid).delete()
            try await curUser.delete()
        }
        catch {
            throw AlertError.delete(error.localizedDescription)
        }
    }
    
    func setUserLabel(completion: @escaping (Result<String, AlertError>) -> ()){
        guard let curUser = Auth.auth().currentUser, let provider = curUser.providerData[0].providerType  else {
            return
        }
        if provider == .email{
            db.collection("User").document(curUser.uid).addSnapshotListener() { (document, err) in
                guard err == nil,
                      let document = document,
                      document.exists,
                      let data = document.data(),
                      let userLable = data["username"] as? String
                else {
                    completion(.failure(AlertError.logout("User is not found!")))
                    return
                }
                completion(.success(userLable))
            }
        }
        else {
            guard let userLable = curUser.displayName else {
                return
            }
            completion(.success(userLable))
        }
    }
}
