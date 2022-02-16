//
//  LoginVC.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 2.01.22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginVC: UIViewController {
    
    @IBOutlet weak var line: UIView!
    @IBOutlet private var usernameField: UITextField!
    @IBOutlet private var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension LoginVC {
    @IBAction func signIn(_ sender: UIButton) {
        // get data from fields and check some fields is empty
        guard let username = usernameField.text,
            let password = passwordField.text,
            !username.isEmpty,
            !password.isEmpty
        else {
            showAlert(alertMessage: "The form must be completed!", title: "Error")
            return
        }
        
        let db = Firestore.firestore()
        // find user
        db.collection("User").whereField("username", isEqualTo: username).getDocuments() { [weak self] (querySnapshot, err) in
            guard err == nil, querySnapshot?.documents.isEmpty == false else {
                self?.showAlert(alertMessage: "User is not found!", title: "Error")
                return
            }
            guard let email = querySnapshot?.documents[0].data()["email"] as? String  else {
                return
            }
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
                guard error == nil else{
                    self?.showAlert(alertMessage: error!.localizedDescription, title: "Error")
                    return
                }
                self?.changeScreen(storyboardName: "Tabs", viewControllerId: "tabs", transition: .crossDissolve)
            }
        }
    }
    
    @IBAction func goToRegister(_ sender: UIButton) {
        changeScreen(storyboardName: "Authentication", viewControllerId: "register", transition: .flipHorizontal)
    }
}
