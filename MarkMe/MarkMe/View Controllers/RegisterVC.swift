//
//  RegisterVC.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 2.01.22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterVC: UIViewController {
    
    @IBOutlet private var usernameField: UITextField!
    @IBOutlet private var emailField: UITextField!
    @IBOutlet private var passwordField: UITextField!
    @IBOutlet private var confirmPassField: UITextField!
    
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension RegisterVC {
    func validateData(email: String ,password: String, confirmPass: String) -> String? {
        let emailPattern = #"^\S+@\S+\.\S+$"#
        guard (email.range(of: emailPattern, options: .regularExpression) != nil) else {
            return "Email is not valid"
        }
        if password.count < 8 {
            return "Password must be 8 or more charecters!"
        }
        if password != confirmPass {
            return "Password not confirmed"
        }
        return nil;
    }
    
    func createUser(username: String, email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, err) in
            // check for errors
            guard err == nil else {
                self?.showAlert(alertMessage: err!.localizedDescription, title: "Regsitration Error")
                return
            }
            // try to save user data in DB
            self?.db.collection("User").document(username).setData(["username": username, "uid": result!.user.uid, "email": email]) { [weak self] (error) in
                // check for errors
                if let error = error {
                    self?.showAlert(alertMessage: error.localizedDescription, title: "Database Error")
                }
            }
            // go to Home screen
            self?.changeScreen(storyboardName: "Tabs", viewControllerId: "tabs", transition: .crossDissolve)
        }
    }
    
    func checkUserExisted(email: String, username: String) -> String? {
        var result: String? = nil
        
        // check username is already used
        db.collection("User").whereField("username", isEqualTo: username).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            guard querySnapshot?.documents.isEmpty == true else {
                result = "Username is already used!"
                return
            }
        }
        
        // check email is already used
        db.collection("User").whereField("email", isEqualTo: email).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            guard querySnapshot?.documents.isEmpty == true else {
                result = "Email is already used!"
                return
            }
        }
        
        return result
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        // get data from fields and check some field is empty
        guard let username = usernameField.text,
            let email = emailField.text,
            let password = passwordField.text,
            let confirmPass = confirmPassField.text,
            !username.isEmpty,
            !email.isEmpty,
            !password.isEmpty,
            !confirmPass.isEmpty
        else {
            showAlert(alertMessage: "The form must be completed!", title: "Error")
            return
        }
        
        // validate data
        if let validationError = validateData(email: email, password: password, confirmPass: confirmPass) {
            showAlert(alertMessage: validationError, title: "Validation Error")
            return
        }
        else {
            // check user existed
            if let userExistError = checkUserExisted(email: email, username: username) {
                showAlert(alertMessage: userExistError, title: "Error")
            }
            else {
                createUser(username: username, email: email, password: password)
            }
        }
    }
    
    @IBAction func goToLogin(_ sender: UIButton) {
        changeScreen(storyboardName: "Authentication", viewControllerId: "login", transition: .flipHorizontal)
    }
    
}
