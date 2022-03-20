//
//  LoginViewModel.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 24.02.22.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FacebookLogin

class LoginViewModel {
    private let db = Firestore.firestore()
    
    func validateData(usernameField: String?, passwordField: String?) -> DBUser? {
        if let username = usernameField, let password = passwordField, !username.isEmpty, !password.isEmpty {
            return DBUser(username: username, password: password)
        }
        return nil
    }
    
    func loginWithUsername(usernameField: String?, passwordField: String?, completion: @escaping (Result<Void, AlertError>) -> ()) {
        // validate form
        guard let user = validateData(usernameField: usernameField, passwordField: passwordField) else{
            return completion(.failure(AlertError.validation("The form must be completed!")))
        }

        // find user
        db.collection("User").whereField("username", isEqualTo: user.username).getDocuments() { (querySnapshot, err) in
            guard err == nil, querySnapshot?.documents.isEmpty == false else {
                completion(.failure(AlertError.db("User is not found!")))
                return
            }
            guard let email = querySnapshot?.documents[0].data()["email"] as? String else {
                completion(.failure(AlertError.db("Can't get email")))
                return
            }
            // sign in user
            Auth.auth().signIn(withEmail: email, password: user.password) { (result, error) in
                if let error = error {
                    completion(.failure(AlertError.login(error.localizedDescription)))
                    return
                }
                completion(.success(()))
            }
        }
    }
    
    func addUser(user: User) -> AlertError? {
        let newUser = DBUser(username: user.displayName!, password: "", email: user.email!)
        do {
            try db.collection("User").document(user.uid).setData(from: newUser)
            return nil
        }
        catch {
            return AlertError.db(error.localizedDescription)
        }
    }
    
    func loginWithFacebook(view: UIViewController, completion: @escaping (Result<Void, AlertError>) -> ()) {
        LoginManager().logIn(permissions: ["public_profile","email"], from: view) { (fbResult, fbError) in
            // check for error
            if let fbError = fbError {
                completion(.failure(AlertError.facebook(fbError.localizedDescription)))
                return
            }
            // check for cancle
            guard fbResult?.isCancelled == false else {
                return
            }
            // make firebase login
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
            Auth.auth().signIn(with: credential) { [weak self] (result, error) in
                if let error = error {
                    completion(.failure(AlertError.login(error.localizedDescription)))
                    return
                }
                guard let user = result?.user else {
                    completion(.failure(AlertError.login("Can't get user")))
                    return
                }
                if let addResult = self?.addUser(user: user) {
                    completion(.failure(addResult))
                }
                // success
                completion(.success(()))
            }
        }
    }
}
