//
//  LoginVC.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 2.01.22.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var line: UIView!
    @IBOutlet private var usernameField: UITextField!
    @IBOutlet private var passwordField: UITextField!
    
    let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension LoginViewController{
    @IBAction func signIn(_ sender: UIButton) {
        viewModel.loginWithUsername(usernameField: usernameField.text, passwordField: passwordField.text) {[weak self] (result) in
            self?.processResult(result: result)
        }
    }
    
    // login with facebook
    @IBAction func loginWithFacebook(_ sender: UIButton) {
        viewModel.loginWithFacebook(view: self) { [weak self] (result) in
            self?.processResult(result: result)
        }
    }

    // registattion button
    @IBAction func goToRegister(_ sender: UIButton) {
        let router = LoginRouter(root: self)
        router.transition = .flipHorizontal
        router.goToNextScreen(storyboardName: "Authentication", storyboardId: "register")
    }
    
    func processResult(result: [String:String]) {
        let router = LoginRouter(root: self)
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
