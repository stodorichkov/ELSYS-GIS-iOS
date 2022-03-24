//
//  UserVC.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 17.01.22.
//

import UIKit

class UserViewController: UIViewController {

    @IBOutlet private var userLabel: UILabel!
    
    private let viewModel = UserViewModel()
    private var router: UserRouter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        router = UserRouter(root: self)
        setUpUserLabel()
    }
    
    func setUpUserLabel() {
        Task {
            do {
                userLabel.text = try await viewModel.setUserLabel()
            }
            catch{
                let alert = error as! AlertError
                showAlert(title: alert.title, alertMessage: alert.errorDescription)
            }
        }
    }
}

extension UserViewController {
    @IBAction func signOut(_ sender: UIButton) {
        Task {
            do {
                try viewModel.signOut()
                self.router?.goToLogin()
            }
            catch {
                let alert = error as! AlertError
                showAlert(title: alert.title, alertMessage: alert.errorDescription)
            }
        }
    }
    
    @IBAction func deleteUser(_ sender: UIButton) {
        Task{
            do {
                try await viewModel.deleteUser()
                self.router?.goToLogin()
            }
            catch {
                let alert = error as! AlertError
                showAlert(title: alert.title, alertMessage: alert.errorDescription)
            }
        }
    }
}
