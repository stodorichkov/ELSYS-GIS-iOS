//
//  RegistrationRouter.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 24.02.22.
//

import UIKit

class RegistrationRouter: Router {
    var root: UIViewController
    
    required init(root: UIViewController) {
        self.root = root
    }
    
    func goToTabs() {
        let target = findViewController(storyboardName: "Tabs", storyboardId: "tabs")
        presentTarget(target: target, transition: .crossDissolve)
    }
    
    func dismiss() {
        root.dismiss(animated: true, completion: nil)
    }
}
