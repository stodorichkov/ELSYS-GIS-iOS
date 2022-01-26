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
    
    
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var textFields: [UITextField]!
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for textField in textFields {
            textField.backgroundColor = .white
            textField.textColor = .black
            textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        
        for button in buttons {
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 2
            button.layer.cornerRadius = 5
        }
    }
}

extension LoginVC {
    @IBAction func signIN(_ sender: UIButton) {
        if usernameField.text?.isEmpty ?? true ||  passwordField.text?.isEmpty ?? true {
            showAlert(alertMessage: "The form must be completed!")
        }
        else {
            // get data from fields
            let username = usernameField.text!
            let password = passwordField.text!
            
            let db = Firestore.firestore()
            // find user
            db.collection("User").whereField("username", isEqualTo: username).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                }
                else {
                    if querySnapshot!.documents.isEmpty {
                        self.showAlert(alertMessage: "User is not found!")
                    }
                    else {
                        let email = querySnapshot!.documents[0].data()["email"]! as! String
                        print(type(of: email))
                        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                            if error != nil {
                                self.showAlert(alertMessage: error!.localizedDescription)
                            }
                            else {
                                self.changeScreen(storyboardName: "Tabs", viewControllerId: "tabs", transition: .crossDissolve)
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    @IBAction func goToRegister(_ sender: UIButton) {
        changeScreen(storyboardName: "Authentication", viewControllerId: "register", transition: .flipHorizontal)
    }
}
