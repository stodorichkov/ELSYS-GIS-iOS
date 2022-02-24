//
//  RegisterVC.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 2.01.22.
//

import UIKit    

class RegistrationViewController: UIViewController {
    
    @IBOutlet private var usernameField: UITextField!
    @IBOutlet private var emailField: UITextField!
    @IBOutlet private var passwordField: UITextField!
    @IBOutlet private var confirmPassField: UITextField!
    
    let viewModel = RegistrationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension RegistrationViewController {
    @IBAction func signUp(_ sender: UIButton) {
        let router = RegistrationRouter(root: self)
        viewModel.RegisterUser(usernameField: usernameField.text, emailField: emailField.text, passwordField: passwordField.text, confirmPassField: confirmPassField.text) { (result) in
            if result["type"] == "alert" {
                guard let title = result["alertTitle"], let message = result["alertMessage"] else {
                    return
                }
                self.showAlert(alertMessage: message , title: title)
            }
            else {
                guard let storyboardName = result["storyboardName"], let viewControllerId = result["viewControllerId"] else {
                    return
                }
                router.goToNextScreen(storyboardName: storyboardName, storyboardId: viewControllerId)
            }
        }
    }
    
    @IBAction func goToLogin(_ sender: UIButton) {
        let router = RegistrationRouter(root: self)
        router.dismiss()
    }
    
}
