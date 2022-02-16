//
//  UserVC.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 17.01.22.
//

import UIKit
import FirebaseAuth

class UserVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signOut(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            changeScreen(storyboardName: "Authentication", viewControllerId: "authentication", transition: .crossDissolve)
        }
        catch let error {
            showAlert(alertMessage: error.localizedDescription, title: "Error")
        }
    }
    
    @IBAction func deleteUser(_ sender: UIButton) {
        changeScreen(storyboardName: "Authentication", viewControllerId: "authentication", transition: .crossDissolve)
    }
}
