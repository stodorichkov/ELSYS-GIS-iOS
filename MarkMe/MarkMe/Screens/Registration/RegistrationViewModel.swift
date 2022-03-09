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
            return .failure(AlertError(title: ErrorTitle.validation.rawValue, message: "The form must be completed!"))
        }
        
        let emailPattern = #"^\S+@\S+\.\S+$"#
        guard (email.range(of: emailPattern, options: .regularExpression) != nil) else {
            return .failure(AlertError(title: ErrorTitle.validation.rawValue, message: "Email is not valid"))
        }
        if password.count < 8 {
            return .failure(AlertError(title: ErrorTitle.validation.rawValue, message: "Password must be 8 or more charecters!"))
        }
        if password != confirmPass {
            return .failure(AlertError(title: ErrorTitle.validation.rawValue, message: "Password not confirmed"))
        }
        return .success(User(username: username, email: email, password: password))
    }
    
    func checkUserExist(username: String, completion: @escaping (AlertError?) -> ()) {
        db.collection("User").whereField("username", isEqualTo: username).getDocuments() { (querySnapshot, err) in
            if let err = err {
                completion(AlertError(title: ErrorTitle.db.rawValue, message: err.localizedDescription))
            }
            guard querySnapshot?.documents.isEmpty == true else {
                completion(AlertError(title: ErrorTitle.registration.rawValue, message: "Username is already used!"))
                return
            }
            completion(nil)
        }
    }
    
    func authUser(user: User, completion: @escaping (Result<String, AlertError>) -> ()) {
        Auth.auth().createUser(withEmail: user.email, password: user.password) { (result, err) in
            // check for errors
            if let err = err{
                completion(.failure(AlertError(title: ErrorTitle.registration.rawValue, message: err.localizedDescription)))
                return
            }
            guard let uid = result?.user.uid else {
                completion(.failure(AlertError(title: ErrorTitle.registration.rawValue, message: "Can't get uid")))
                return
            }
            completion(.success(uid))
        }
    }
    
    func addUser(user: User) -> AlertError? {
        do {
            let _ = try db.collection("User").addDocument(from: user)
            return nil
        }
        catch {
            return AlertError(title: ErrorTitle.db.rawValue, message: error.localizedDescription)
        }
    }
    
    func registerUser(usernameField: String?, emailField: String? ,passwordField: String?, confirmPassField: String?,
                      completion: @escaping (Result<Void, AlertError>) -> ()) {
        // validate data
        let vaidationResult = validateData(usernameField: usernameField, emailField: emailField, passwordField: passwordField, confirmPassField: confirmPassField)
        var newUser: User
        switch vaidationResult {
        case .success(let user):
            newUser = user
        case .failure(let alert):
            completion(.failure(alert))
            return
        }
        
        // check user with this username exist
        checkUserExist(username: newUser.username) { [weak self] (alert) in
            if let alert = alert {
                completion(.failure(alert))
                return
            }
            // authenticate user
            self?.authUser(user: newUser) { (result) in
                switch result {
                case .success(let uid):
                    // add user in db
                    newUser.uid = uid
                    if let dbResult = self?.addUser(user: newUser) {
                        completion(.failure(dbResult))
                        return
                    }
                    completion(.success(()))
                case .failure(let alert):
                    completion(.failure(alert))
                    return
                }
            }
        }
    }
}
