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
    func loginWithUsername(usernameField: String?, passwordField: String?, completion: @escaping (Result<ScreenInfo, AlertError>) -> ()) {
        // validate form
        let vaidationResult = validateData(usernameField: usernameField, passwordField: passwordField)
        var username, password: String
        switch vaidationResult {
        case .success(let user):
            username = user.username
            password = user.password
        case .failure(let alert):
            completion(.failure(alert))
            return
        }

        // find user
        let db = Firestore.firestore()
        db.collection("User").whereField("username", isEqualTo: username).getDocuments() { (querySnapshot, err) in
            guard err == nil, querySnapshot?.documents.isEmpty == false else {
                completion(.failure(AlertError(title: "Login Error", message: "User is not found!")))
                return
            }
            guard let email = querySnapshot?.documents[0].data()["email"] as? String else {
                return
            }
            // sign in user
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    completion(.failure(AlertError(title: "Login Error", message: error.localizedDescription)))
                    return
                }
                completion(.success(ScreenInfo(storyboardName: "Tabs", storyboardId: "tabs")))
            }
        }
    }
    
    func validateData(usernameField: String?, passwordField: String?) -> Result<User, AlertError> {
        if let username = usernameField, let password = passwordField, !username.isEmpty, !password.isEmpty {
            return .success(User(username: username, password: password))
        }
        else {
            return .failure(AlertError(title: "Validation Error", message: "The form must be completed!"))
        }
    }
    
    func loginWithFacebook(view: UIViewController, completion: @escaping (Result<ScreenInfo, AlertError>) -> ()) {
        LoginManager().logIn(permissions: ["public_profile","email"], from: view) { (fbResult, fbError) in
            // check for error
            if let fbError = fbError {
                completion(.failure(AlertError(title: "Facebook Error", message: fbError.localizedDescription)))
                return
            }
            // check for cancle
            guard fbResult?.isCancelled == false else {
                return
            }
            // make firebase login
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
            Auth.auth().signIn(with: credential) { (result, error) in
                if let error = error {
                    completion(.failure(AlertError(title: "Facebook Error", message: error.localizedDescription)))
                    return
                }
                // success
                completion(.success(ScreenInfo(storyboardName: "Tabs", storyboardId: "tabs")))
            }
        }
    }
}
