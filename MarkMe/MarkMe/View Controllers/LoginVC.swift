//
//  LoginVC.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 2.01.22.
//

import UIKit

class LoginVC: UIViewController {
    
    
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var textFields: [UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for textField in textFields {
            textField.backgroundColor = .white
            textField.textColor = .black
            textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        
        for button in buttons {
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 2
            button.layer.cornerRadius = 5
        }
        
    }

    @IBAction func goToRegister(_ sender: UIButton) {
        changeScreen(storyboardName: "Authentication", viewControllerId: "register")
    }
    
}
