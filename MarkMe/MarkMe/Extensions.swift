//
//  Helper.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 23.01.22.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, alertMessage: String) {
        let alert = UIAlertController(title: title, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        alert.view.tintColor = .red
        
        present(alert, animated: true)
    }
}

