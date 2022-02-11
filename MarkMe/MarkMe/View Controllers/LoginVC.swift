//
//  LoginVC.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 2.01.22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FacebookLogin

class LoginVC: UIViewController {
    
    
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var textFields: [UITextField]!
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var fbButton: FBButton!
    
    
    
    
    
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
            button.titleLabel?.font = UIFont(name: "Helvetica Neue Bold", size: 18)
        }
        
        fbButton.setTitle("Sign in with Facebook", for: .normal)
        fbButton.titleLabel?.textAlignment = .center
    }
     
}

extension LoginVC {
    // sign in button
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
    
    // login with facebook
    @IBAction func loginWithFacebook(_ sender: UIButton) {
        LoginManager().logIn(permissions: ["public_profile","email"], from: self) { (fbResult, fbError) in
            // check for error
            if fbError != nil {
                self.showAlert(alertMessage: fbError!.localizedDescription)
            }
            else {
                // check for cancle
                if fbResult!.isCancelled {
                    return
                }
                // make firebase login
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                Auth.auth().signIn(with: credential) { (result, error) in
                    if error != nil {
                        self.showAlert(alertMessage: fbError!.localizedDescription)
                    }
                    else {
                        // success
                        self.changeScreen(storyboardName: "Tabs", viewControllerId: "tabs", transition: .crossDissolve)
                    }
                }
            }
        }
    }

    
    
    
    // registattion button
    @IBAction func goToRegister(_ sender: UIButton) {
        changeScreen(storyboardName: "Authentication", viewControllerId: "register", transition: .flipHorizontal)
    }
}
