//
//  RegistrationViewModel.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 24.02.22.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class RegistrationViewModel {
    let db = Firestore.firestore()
    
    func RegisterUser(usernameField: String?, emailField: String? ,passwordField: String?, confirmPassField: String?,
                      completion: @escaping (Result<ScreenInfo, AlertError>) -> ()) {
        // validate data
        let vaidationResult = validateData(usernameField: usernameField, emailField: emailField, passwordField: passwordField, confirmPassField: confirmPassField)
        var username, email, password: String
        switch vaidationResult {
        case .success(let user):
            username = user.username
            email = user.email
            password = user.password
            
        case .failure(let alert):
            completion(.failure(alert))
            return
        }
        
        // check user with this username exist
        db.collection("User").whereField("username", isEqualTo: username).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            guard querySnapshot?.documents.isEmpty == true else {
                completion(.failure(AlertError(title: "Regsitration Error", message: "Username is already used!")))
                return
            }
            // try to create user
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, err) in
                // check for errors
                if let err = err {
                    completion(.failure(AlertError(title: "Regsitration Error", message: err.localizedDescription)))
                    return
                }
                // try to save user data in DB
                self?.db.collection("User").document(username).setData(["username": username, "uid": result!.user.uid, "email": email]) { (error) in
                    // check for errors
                    if let error = error {
                        completion(.failure(AlertError(title: "Database Error", message: error.localizedDescription)))
                        return
                    }
                }
                // go to Home screen
                completion(.success(ScreenInfo(storyboardName: "Tabs", storyboardId: "tabs")))
            }
        }
    }
    
    func validateData(usernameField: String?, emailField: String? ,passwordField: String?, confirmPassField: String?) -> Result<User, AlertError> {
        guard let username = usernameField,
            let email = emailField,
            let password = passwordField,
            let confirmPass = confirmPassField,
            !username.isEmpty,
            !email.isEmpty,
            !password.isEmpty,
            !confirmPass.isEmpty
        else {
            return .failure(AlertError(title: "Validation Error", message: "The form must be completed!"))
        }
        
        let emailPattern = #"^\S+@\S+\.\S+$"#
        guard (email.range(of: emailPattern, options: .regularExpression) != nil) else {
            return .failure(AlertError(title: "Validation Error", message: "Email is not valid"))
        }
        if password.count < 8 {
            return .failure(AlertError(title: "Validation Error", message: "Password must be 8 or more charecters!"))
        }
        if password != confirmPass {
            return .failure(AlertError(title: "Validation Error", message: "Password not confirmed"))
        }
        return .success(User(username: username, email: email, password: password))
    }
    
}
