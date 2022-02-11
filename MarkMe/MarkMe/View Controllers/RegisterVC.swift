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

    @IBOutlet var button: UIButton!
    @IBOutlet var textFields: [UITextField]!
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPassField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for textField in textFields {
            textField.backgroundColor = .white
            textField.textColor = .black
            textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 5
        
        // Do any additional setup after loading the view.
    }
    
    
}

extension RegisterVC {
    
    func createUser(username: String, email: String, password: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            // check for errors
            if err != nil {
                self.showAlert(alertMessage: err!.localizedDescription)
            }
            else {
                // try to save user data in DB
                let db = Firestore.firestore()
                db.collection("User").document(username).setData(["username": username, "uid": result!.user.uid, "email": email]) { (error) in
                    // check for errors
                    if error != nil {
                        self.showAlert(alertMessage: error!.localizedDescription)
                    }
                }
                // go to Home screen
                self.changeScreen(storyboardName: "Tabs", viewControllerId: "tabs", transition: .crossDissolve)
            }
        }
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        // check some fields is empty
        if usernameField.text?.isEmpty ?? true || emailField.text?.isEmpty ?? true || passwordField.text?.isEmpty ?? true || confirmPassField.text?.isEmpty ?? true {
            showAlert(alertMessage: "The form must be completed!")
        }
        else {
            // get data from fields
            let username = usernameField.text!
            let email = emailField.text!
            let password = passwordField.text!
            let confirmPass = confirmPassField.text!
            
            // validate data
            if password.count < 8 {
                showAlert(alertMessage: "Password must be 8 or more charecters!")
            }
            else if password != confirmPass {
                showAlert(alertMessage: "Password not confirmed")
            }
            else {
                let db = Firestore.firestore()
                // check username is already taken
                db.collection("User").whereField("username", isEqualTo: username).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    }
                    else {
                        if querySnapshot!.documents.isEmpty {
                            // create user
                            self.createUser(username: username, email: email, password: password)
                        }
                        else {
                            self.showAlert(alertMessage: "Username is already taken!")
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func goToLogin(_ sender: UIButton) {
        changeScreen(storyboardName: "Authentication", viewControllerId: "login", transition: .flipHorizontal)
    }
    
}
