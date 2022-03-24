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
    
    func signOut() throws {
        do {
            try Auth.auth().signOut()
        }
        catch let error {
            throw AlertError.logout(error.localizedDescription)
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
    
    func setUserLabel() async throws -> String? {
        guard let curUser = Auth.auth().currentUser else {
            return nil
        }
        do {
            let document = try await db.collection("User").document(curUser.uid).getDocument()
            let user = try document.data(as: DBUser.self)
            return user?.username
        }
        catch {
            throw AlertError.db("User is not found!")
        }
    }
}
