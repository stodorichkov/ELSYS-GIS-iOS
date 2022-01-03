//
//  AuthenticationVC.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 2.01.22.
//

import UIKit

class AuthenticationVC: UIViewController {
    @IBOutlet var buttons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for button in buttons {
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 2
            button.layer.cornerRadius = 5
        }
    }
    
    @IBAction func goToLogin(_ sender: UIButton) {
        changeScreen(storyboardName: "Authentication", viewControllerId: "login")
    }
    
    
    @IBAction func goToRegister(_ sender: UIButton) {
        changeScreen(storyboardName: "Authentication", viewControllerId: "register")
    }
    
}
