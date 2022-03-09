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
    
    func goTo(target: UIViewController, transition: UIModalTransitionStyle) {
        target.modalPresentationStyle = .fullScreen
        target.modalTransitionStyle = transition
        root.present(target, animated: true)
    }
    
    func goToRegistration() {
        let target = findViewController(storyboardName: "Authentication", storyboardId: "register")
        goTo(target: target, transition: .flipHorizontal)
    }
    
    func goToTabs() {
        let target = findViewController(storyboardName: "Tabs", storyboardId: "tabs")
        goTo(target: target, transition: .crossDissolve)
    }
}
