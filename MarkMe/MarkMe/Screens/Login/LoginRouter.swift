//
//  LoginRouter.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 24.02.22.
//

import Foundation
import UIKit

class LoginRouter: Router {
    var root: UIViewController
    var transition: UIModalTransitionStyle
    
    required init(root: UIViewController) {
        self.root = root
        transition = .crossDissolve
    }
    
    func goToNextScreen(storyboardName: String, storyboardId: String) {
        let target = findViewController(storyboardName: storyboardName, storyboardId: storyboardId)
        target.modalPresentationStyle = .fullScreen
        target.modalTransitionStyle = transition
        root.present(target, animated: true)
    }
}
