//
//  Helper.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 23.01.22.
//

import UIKit

extension UIViewController {
    func changeScreen(storyboardName: String, viewControllerId: String, transition: UIModalTransitionStyle) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerId)
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = transition
        present(viewController, animated: true, completion: nil)
    }
    
    func navigateToScreen(storyboardName: String, viewControllerId: String) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerId)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showAlert(alertMessage: String, title: String) {
        let alert = UIAlertController(title: title, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        alert.view.tintColor = .red
        
        present(alert, animated: true)
    }
}
