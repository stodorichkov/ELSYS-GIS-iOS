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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setUserLabel() { (result) in
            if result["type"] == "alert" {
                guard let title = result["alertTitle"], let message = result["alertMessage"] else {
                    return
                }
                self.showAlert(alertMessage: message , title: title)
            }
            else {
                self.userLabel.text = result["userLable"]
            }
        }
    }
}

extension UserViewController {
    @IBAction func signOut(_ sender: UIButton) {
        let router = UserRouter(root: self)
        viewModel.signOut() { [weak self] (result) in
            if result["type"] == "alert" {
                guard let title = result["alertTitle"], let message = result["alertMessage"] else {
                    return
                }
                self?.showAlert(alertMessage: message , title: title)
            }
            else {
                guard let storyboardName = result["storyboardName"], let viewControllerId = result["viewControllerId"] else {
                    return
                }
                router.goToNextScreen(storyboardName: storyboardName, storyboardId: viewControllerId)
            }
        }
    }
    
    @IBAction func deleteUser(_ sender: UIButton) {
        let router = UserRouter(root: self)
        router.goToNextScreen(storyboardName: "Authentication", storyboardId: "login")
    }
}
