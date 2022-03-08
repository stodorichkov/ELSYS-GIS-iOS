//
//  MainRouter.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 20.02.22.
//

import Foundation
import UIKit

class MainRouter: Router {
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
    
}
