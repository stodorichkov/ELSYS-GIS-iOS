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
    
    func goToNextScreen(storyboardName: String, storyboardId: String) {
        let target = findViewController(storyboardName: storyboardName, storyboardId: storyboardId)
        target.modalPresentationStyle = .fullScreen
        target.modalTransitionStyle = .crossDissolve
        root.present(target, animated: true)
    }
    
    func dismiss() {
        root.dismiss(animated: true, completion: nil)
    }
}
