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
    // login with username and password
    @IBAction func signIn(_ sender: UIButton) {
        viewModel.loginWithUsername(usernameField: usernameField.text, passwordField: passwordField.text) {[weak self] (result) in
            self?.processResult(result: result, transition: .crossDissolve)
        }
    }
    
    // login with facebook
    @IBAction func loginWithFacebook(_ sender: UIButton) {
        viewModel.loginWithFacebook(view: self) { [weak self] (result) in
            self?.processResult(result: result, transition: .crossDissolve)
        }
    }

    // go to registation screen
    @IBAction func goToRegister(_ sender: UIButton) {
        let screen = ScreenInfo(storyboardName: "Authentication", storyboardId: "register")
        self.processResult(result: .success(screen), transition: .flipHorizontal)
    }
    
    // process result
    func processResult(result: Result<ScreenInfo, AlertError>, transition: UIModalTransitionStyle) {
        let router = LoginRouter(root: self)
        router.transition = transition
        switch result {
        case .success(let screen):
            router.goToNextScreen(storyboardName: screen.storyboardName, storyboardId: screen.storyboardId)
        case .failure(let alert):
            self.showAlert(title: alert.title, alertMessage: alert.message)
        }
    }
}
