//
//  UserRouter.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 24.02.22.
//

import UIKit

class UserRouter: Router {
    var root: UIViewController
    
    required init(root: UIViewController) {
        self.root = root
    }
    
    func goToLogin() {
        let target = findViewController(storyboardName: "Authentication", storyboardId: "login")
        presentTarget(target: target, transition: .crossDissolve)
    }
}
