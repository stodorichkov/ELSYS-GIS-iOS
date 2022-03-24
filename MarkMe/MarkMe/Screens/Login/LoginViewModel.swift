//
//  LoginViewModel.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 24.02.22.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Firebase
import FacebookLogin
import GoogleSignIn

class LoginViewModel {
    private let db = Firestore.firestore()
    
    func validateData(usernameField: String?, passwordField: String?) -> DBUser? {
        if let username = usernameField, let password = passwordField, !username.isEmpty, !password.isEmpty {
            return DBUser(username: username, password: password)
        }
        return nil
    }
    
    func loginWithUsername(usernameField: String?, passwordField: String?, completion: @escaping (AlertError?) -> ()) {
        // validate form
        guard let user = validateData(usernameField: usernameField, passwordField: passwordField) else{
            return completion(AlertError.validation("The form must be completed!"))
        }

        // find user
        db.collection("User").whereField("username", isEqualTo: user.username).getDocuments() { (querySnapshot, err) in
            guard err == nil, querySnapshot?.documents.isEmpty == false else {
                completion(AlertError.db("User is not found!"))
                return
            }
            guard let email = querySnapshot?.documents[0].data()["email"] as? String else {
                completion(AlertError.db("Can't get email"))
                return
            }
            // sign in user
            Auth.auth().signIn(withEmail: email, password: user.password) { (result, error) in
                if let error = error {
                    completion(AlertError.login(error.localizedDescription))
                    return
                }
                completion(nil)
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
    
    func firebaseAuth(credential: AuthCredential, completion: @escaping (AlertError?) -> ()) {
        Auth.auth().signIn(with: credential) { [weak self] (result, error) in
            if let error = error {
                completion(AlertError.login(error.localizedDescription))
                return
            }
            guard let user = result?.user else {
                completion(AlertError.login("Can't get user"))
                return
            }
            if let addResult = self?.addUser(user: user) {
                completion(addResult)
            }
            // success
            completion(nil)
        }
    }
    
    func loginWithFacebook(view: UIViewController, completion: @escaping (AlertError?) -> ()) {
        LoginManager().logIn(permissions: ["public_profile","email"], from: view) { [weak self] (fbResult, fbError) in
            // check for error
            if let fbError = fbError {
                completion(AlertError.facebook(fbError.localizedDescription))
                return
            }
            // check for cancle
            guard fbResult?.isCancelled == false else {
                return
            }
            // make firebase login
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
            self?.firebaseAuth(credential: credential) { (alert) in
                completion(alert)
            }
        }
    }
    
    func loginWithGoogle(root: UIViewController, completion: @escaping (AlertError?) -> ()) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: root) { [weak self] (user, error) in
            if let error = error {
                if error.localizedDescription != "The user canceled the sign-in flow." {
                    completion(AlertError.google(error.localizedDescription))
                }
                return
            }
            
            guard let authentication = user?.authentication, let idToken = authentication.idToken else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            self?.firebaseAuth(credential: credential) { (alert) in
                completion(alert)
            }
        }
    }
}
