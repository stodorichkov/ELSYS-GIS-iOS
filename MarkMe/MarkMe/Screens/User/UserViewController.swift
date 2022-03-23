//
//  UserVC.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 17.01.22.
//

import UIKit
import FirebaseAuth
import FacebookLogin
import FirebaseFirestore

class UserViewController: UIViewController {

    @IBOutlet private var userLabel: UILabel!
    
    private let viewModel = UserViewModel()
    private var router: UserRouter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        router = UserRouter(root: self)
        viewModel.setUserLabel() { [weak self] (result) in
            switch result {
            case .success(let userLable):
                self?.userLabel.text = userLable
            case .failure(let alert):
                self?.showAlert(title: alert.title, alertMessage: alert.errorDescription)
            }
        }
    }
}

extension UserViewController {
    @IBAction func signOut(_ sender: UIButton) {
        viewModel.signOut() { [weak self] (alert) in
            if let alert = alert {
                self?.showAlert(title: alert.title, alertMessage: alert.errorDescription)
            }
            else {
                self?.router?.goToLogin()
            }
        }
    }
    
    @IBAction func deleteUser(_ sender: UIButton) {
        Task{
            do {
                try await viewModel.deleteUser()
            }
            catch {
                let error = error as! AlertError
                showAlert(title: error.title, alertMessage: error.errorDescription)
            }
        }
    }
}
