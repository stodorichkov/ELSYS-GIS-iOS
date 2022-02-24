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
import UIKit

class LoginViewModel {
    func loginWithUsername(usernameField: String?, passwordField: String?, completion: @escaping ([String: String]) -> ()) {
        // validate form
        let vaidationDict = validateData(usernameField: usernameField, passwordField: passwordField)
        guard let username = vaidationDict["username"], let password = vaidationDict["password"] else {
            completion(vaidationDict)
            return
        }

        // find user
        let db = Firestore.firestore()
        db.collection("User").whereField("username", isEqualTo: username).getDocuments() { (querySnapshot, err) in
            guard err == nil, querySnapshot?.documents.isEmpty == false else {
                completion(["type": "alert", "alertTitle": "Error", "alertMessage": "User is not found!"])
                return
            }
            guard let email = querySnapshot?.documents[0].data()["email"] as? String else {
                return
            }
            // sign in user
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    completion(["type": "alert", "alertTitle": "Error", "alertMessage": error.localizedDescription])
                    return
                }
                completion(["storyboardName": "Tabs", "viewControllerId": "tabs"])
            }
        }
    }
    
    func validateData(usernameField: String?, passwordField: String?) -> [String:String] {
        if let username = usernameField, let password = passwordField, !username.isEmpty, !password.isEmpty {
            return ["username": username, "password": password]
        }
        else {
            return ["type": "alert", "alertTitle": "Error", "alertMessage": "The form must be completed!"]
        }
    }
    
    func loginWithFacebook(view: UIViewController, completion: @escaping ([String: String]) -> ()) {
        LoginManager().logIn(permissions: ["public_profile","email"], from: view) { (fbResult, fbError) in
            // check for error
            if let fbError = fbError {
                completion(["type": "alert", "alertTitle": "Facebook Error", "alertMessage": fbError.localizedDescription])
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
                    completion(["type": "alert", "alertTitle": "Facebook Error", "alertMessage": error.localizedDescription])
                    return
                }
                // success
                completion(["storyboardName": "Tabs", "viewControllerId": "tabs"])
            }
        }
    }
}
