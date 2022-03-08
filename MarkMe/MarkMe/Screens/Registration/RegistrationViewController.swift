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
    var router: RegistrationRouter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        router = RegistrationRouter(root: self)
    }
}

extension RegistrationViewController {
    @IBAction func signUp(_ sender: UIButton) {
        viewModel.registerUser(usernameField: usernameField.text, emailField: emailField.text, passwordField: passwordField.text, confirmPassField: confirmPassField.text) { [weak self] (result) in
            switch result {
            case .success(_):
                self?.router?.goToTabs()
            case .failure(let alert):
                self?.showAlert(title: alert.title, alertMessage: alert.message)
            }
        }
    }
    
    @IBAction func goToLogin(_ sender: UIButton) {
        router?.dismiss()
    }
    
}
