//
//  ForgotPasswordRouter.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 24.03.22.
//

import UIKit

class ForgotPasswordRouter: Router {
    var root: UIViewController
    
    required init(root: UIViewController) {
        self.root = root
    }
    
    func dismiss() {
        root.dismiss(animated: true, completion: nil)
    }
}
