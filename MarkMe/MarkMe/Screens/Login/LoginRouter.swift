//
//  LoginRouter.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 24.02.22.
//

import UIKit

class LoginRouter: Router {
    var root: UIViewController
    
    required init(root: UIViewController) {
        self.root = root
    }

    
    func goToForgotPassword() {
        let target = findViewController(storyboardName: "Authentication", storyboardId: "forgotPassword")
        presentTarget(target: target, transition: .coverVertical)
    }
    
    func goToRegistration() {
        let target = findViewController(storyboardName: "Authentication", storyboardId: "register")
        presentTarget(target: target, transition: .flipHorizontal)
    }
    
    func goToTabs() {
        let target = findViewController(storyboardName: "Tabs", storyboardId: "tabs")
        presentTarget(target: target, transition: .crossDissolve)
    }
}
