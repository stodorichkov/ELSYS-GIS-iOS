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
    func signOut(completion: ([String: String]) -> ()) {
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
            completion(["storyboardName": "Authentication", "viewControllerId": "login"])
        }
        catch let error {
            completion(["type": "alert", "alertTitle": "Error", "alertMessage": error.localizedDescription])
        }
    }
    
    func setUserLabel(completion: @escaping ([String: String]) -> ()) {
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
                    completion(["type": "alert", "alertTitle": "Error", "alertMessage": "User is not found!"])
                    return
                }
                guard let userLable = querySnapshot?.documents[0].data()["username"] as? String else {
                    return
                }
                completion(["userLable": userLable])
            }
        }
        else {
            guard let userLable = curUser.displayName else {
                return
            }
            completion(["userLable": userLable])
        }
    }
}
