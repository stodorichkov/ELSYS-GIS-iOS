//
//  UserVC.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 17.01.22.
//

import UIKit

class UserVC: UIViewController {

    @IBOutlet var buttons: [UIButton]!
    override func viewDidLoad() {
        super.viewDidLoad()
        for button in buttons {
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 2
            button.layer.cornerRadius = 5
        }

        // Do any additional setup after loading the view.
    }
    

    @IBAction func signOut(_ sender: UIButton) {
        changeScreen(storyboardName: "Authentication", viewControllerId: "authentication", transition: .crossDissolve)
    }
    
    @IBAction func deleteUser(_ sender: UIButton) {
        changeScreen(storyboardName: "Authentication", viewControllerId: "authentication", transition: .crossDissolve)
    }
}
