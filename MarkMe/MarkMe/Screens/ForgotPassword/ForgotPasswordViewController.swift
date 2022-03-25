//
//  ForgotPasswordViewController.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 24.03.22.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet private var emailTextField: TextField!
    
    private let viewModel = ForgotPasswordViewModel()
    private var router: ForgotPasswordRouter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        router = ForgotPasswordRouter(root: self)
    }
}

extension ForgotPasswordViewController {
    @IBAction func goBack(_ sender: UIButton) {
        router?.dismiss()
    }
    
    @IBAction func forgotPassDidTap(_ sender: UIButton) {
        Task {
            do {
                try await viewModel.passwordReset(email: emailTextField.text)
                router?.dismiss()
            }
            catch {
                let error = error as! AlertError
                showAlert(title: error.title, alertMessage: error.errorDescription)
            }
        }
    }
}
