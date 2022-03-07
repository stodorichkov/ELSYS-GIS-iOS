//
//  HomeRouter.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 24.02.22.
//

import UIKit

class HomeRouter: Router {
    var root: UIViewController
    
    required init(root: UIViewController) {
        self.root = root
    }
    
    func goToNextScreen(storyboardName: String, storyboardId: String) {
        let target = findViewController(storyboardName: storyboardName, storyboardId: storyboardId)
        root.navigationController?.pushViewController(target, animated: true)
    }
}
