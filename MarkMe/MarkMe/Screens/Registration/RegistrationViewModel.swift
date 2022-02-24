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
                      completion: @escaping ([String: String]) -> ()) {
        // validate data
        let vaidationDict = validateData(usernameField: usernameField, emailField: emailField, passwordField: passwordField, confirmPassField: confirmPassField)
        guard let username = vaidationDict["username"],
              let email = vaidationDict["email"],
              let password = vaidationDict["password"],
              let _ = vaidationDict["confirmPass"]
        else {
            completion(vaidationDict)
            return
        }
        
        // check user with this username exist
        db.collection("User").whereField("username", isEqualTo: username).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            guard querySnapshot?.documents.isEmpty == true else {
                completion(["type": "alert", "alertTitle": "Regsitration Error", "alertMessage": "Username is already used!"])
                return
            }
            // try to create user
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, err) in
                // check for errors
                if let err = err {
                    completion(["type": "alert", "alertTitle": "Regsitration Error", "alertMessage": err.localizedDescription])
                    return
                }
                // try to save user data in DB
                self?.db.collection("User").document(username).setData(["username": username, "uid": result!.user.uid, "email": email]) { (error) in
                    // check for errors
                    if let error = error {
                        completion(["type": "alert", "alertTitle": "Database Error", "alertMessage": error.localizedDescription])
                        return
                    }
                }
                // go to Home screen
                completion(["storyboardName": "Tabs", "viewControllerId": "tabs"])
            }
        }
    }
    
    func validateData(usernameField: String?, emailField: String? ,passwordField: String?, confirmPassField: String?) -> [String:String] {
        guard let username = usernameField,
            let email = emailField,
            let password = passwordField,
            let confirmPass = confirmPassField,
            !username.isEmpty,
            !email.isEmpty,
            !password.isEmpty,
            !confirmPass.isEmpty
        else {
            return ["type": "alert", "alertTitle": "Validation Error", "alertMessage": "The form must be completed!"]
        }
        
        let emailPattern = #"^\S+@\S+\.\S+$"#
        guard (email.range(of: emailPattern, options: .regularExpression) != nil) else {
            return ["type": "alert", "alertTitle": "Validation Error", "alertMessage": "Email is not valid"]
        }
        if password.count < 8 {
            return ["type": "alert", "alertTitle": "Validation Error", "alertMessage": "Password must be 8 or more charecters!"]
        }
        if password != confirmPass {
            return ["type": "alert", "alertTitle": "Validation Error", "alertMessage": "Password not confirmed"]
        }
        return ["username": username, "email": email, "password": password, "confirmPass": confirmPass];
    }
    
}
