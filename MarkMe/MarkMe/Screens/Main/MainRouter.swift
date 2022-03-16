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
    
    func goToLogin() {
        let target = findViewController(storyboardName: "Authentication", storyboardId: "login")
        presentTarget(target: target, transition: .crossDissolve)
    }
    
    func goToTabs() {
        let target = findViewController(storyboardName: "Tabs", storyboardId: "tabs")
        presentTarget(target: target, transition: .crossDissolve)
    }
}
