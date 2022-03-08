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

    @IBOutlet weak var userLabel: UILabel!
    
    let viewModel = UserViewModel()
    var router: UserRouter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        router = UserRouter(root: self)
        viewModel.setUserLabel() { [weak self] (result) in
            switch result {
            case .success(let userLable):
                self?.userLabel.text = userLable
            case .failure(let alert):
                self?.showAlert(title: alert.title, alertMessage: alert.message)
            }
        }
    }
}

extension UserViewController {
    @IBAction func signOut(_ sender: UIButton) {
        viewModel.signOut() { [weak self] (result) in
            switch result {
            case .success(_):
                self?.router?.goToLogin()
            case .failure(let alert):
                self?.showAlert(title: alert.title, alertMessage: alert.message)
            }
        }
    }
    
    @IBAction func deleteUser(_ sender: UIButton) {
        router?.goToLogin()
    }
}
