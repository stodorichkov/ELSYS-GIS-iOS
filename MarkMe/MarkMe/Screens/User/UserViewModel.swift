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
    func signOut(completion: (Result<Void, AlertError>) -> ()) {
        do {
            guard let provider = Auth.auth().currentUser?.providerData[0].providerType else{
                return
            }
            switch provider {
            case .facebook:
                LoginManager().logOut()
            default:
                break
            }
            
            try Auth.auth().signOut()
            completion(.success(()))
        }
        catch let error {
            completion(.failure(AlertError.logout(error.localizedDescription)))
        }
    }
    
    func setUserLabel(completion: @escaping (Result<String, AlertError>) -> ()){
        guard let curUser = Auth.auth().currentUser, let provider = curUser.providerData[0].providerType  else {
            return
        }
        if provider == .email{
            let db = Firestore.firestore()
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
