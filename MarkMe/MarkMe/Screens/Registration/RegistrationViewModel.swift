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
    
    func validateData(usernameField: String?, emailField: String? ,passwordField: String?, confirmPassField: String?) throws -> DBUser {
        guard let username = usernameField,
            let email = emailField,
            let password = passwordField,
            let confirmPass = confirmPassField,
            !username.isEmpty,
            !email.isEmpty,
            !password.isEmpty,
            !confirmPass.isEmpty
        else {
            throw AlertError.validation("The form must be completed!")
        }
        
        let emailPattern = #"^\S+@\S+\.\S+$"#
        guard (email.range(of: emailPattern, options: .regularExpression) != nil) else {
            throw AlertError.validation("Email is not valid")
        }
        if password.count < 8 {
            throw AlertError.validation("Password must be 8 or more charecters!")
        }
        if password != confirmPass {
            throw AlertError.validation("Password not confirmed")
        }
        return DBUser(username: username, password: password, email: email)
    }
    
    func checkUserExist(username: String, completion: @escaping (AlertError?) -> ()) {
        db.collection("User").whereField("username", isEqualTo: username).getDocuments() { (querySnapshot, err) in
            if let err = err {
                completion(AlertError.db(err.localizedDescription))
            }
            guard querySnapshot?.documents.isEmpty == true else {
                completion(AlertError.registration("Username is already used!"))
                return
            }
            completion(nil)
        }
    }
    
    func authUser(user: DBUser, completion: @escaping (Result<String, AlertError>) -> ()) {
        Auth.auth().createUser(withEmail: user.email, password: user.password) { (result, err) in
            // check for errors
            if let err = err{
                completion(.failure(AlertError.registration(err.localizedDescription)))
                return
            }
            guard let uid = result?.user.uid else {
                completion(.failure(AlertError.registration("Can't get uid")))
                return
            }
            completion(.success(uid))
        }
    }
    
    func addUser(uid: String, user: DBUser) -> AlertError? {
        do {
            try db.collection("User").document(uid).setData(from: user)
            return nil
        }
        catch {
            return AlertError.db(error.localizedDescription)
        }
    }
    
    func registerUser(usernameField: String?, emailField: String? ,passwordField: String?, confirmPassField: String?,
                      completion: @escaping (Result<Void, AlertError>) -> ()) {
        // validate data
        do {
            let newUser = try validateData(usernameField: usernameField, emailField: emailField, passwordField: passwordField, confirmPassField: confirmPassField)
            
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
                        if let dbResult = self?.addUser(uid: uid ,user: newUser) {
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
        catch {
            completion(.failure(error as! AlertError))
        }
    }
}
