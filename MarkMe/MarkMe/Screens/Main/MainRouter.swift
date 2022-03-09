//
//  MainRouter.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 20.02.22.
//

import UIKit

class MainRouter: Router {
    var root: UIViewController
    
    required init(root: UIViewController) {
        self.root = root
    }
    
    func goTo(target: UIViewController) {
        target.modalPresentationStyle = .fullScreen
        target.modalTransitionStyle = .crossDissolve
        root.present(target, animated: true)
    }
    
    func goToLogin() {
        let target = findViewController(storyboardName: "Authentication", storyboardId: "login")
        goTo(target: target)
    }
    
    func goToTabs() {
        let target = findViewController(storyboardName: "Tabs", storyboardId: "tabs")
        goTo(target: target)
    }
}
