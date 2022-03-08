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
    func signOut(completion: (Result<ScreenInfo, AlertError>) -> ()) {
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
            completion(.success(ScreenInfo(storyboardName: "Authentication", storyboardId: "login")))
        }
        catch let error {
            completion(.failure(AlertError(title: ErrorTitle.logout.rawValue, message: error.localizedDescription)))
        }
    }
    
    func setUserLabel(completion: @escaping (Result<String, AlertError>) -> ()) {
        guard let curUser = Auth.auth().currentUser, let provider = curUser.providerData[0].providerType  else {
            return
        }
        if provider == .email{
            let db = Firestore.firestore()
            guard let email = curUser.email else{
                return
            }
            db.collection("User").whereField("email", isEqualTo: email).getDocuments() { (querySnapshot, err) in
                guard err == nil, querySnapshot?.documents.isEmpty == false else {
                    completion(.failure(AlertError(title: ErrorTitle.db.rawValue, message: "User is not found!")))
                    return
                }
                guard let userLable = querySnapshot?.documents[0].data()["username"] as? String else {
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
