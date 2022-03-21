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
    
    func goToCreateMark() {
        let target = findViewController(storyboardName: "Marks", storyboardId: "createMark")
        root.navigationController?.pushViewController(target, animated: true)
    }
    
    func goToMarkInfo() {
        let target = findViewController(storyboardName: "Marks", storyboardId: "showMark")
        root.navigationController?.pushViewController(target, animated: true)
    }
}
