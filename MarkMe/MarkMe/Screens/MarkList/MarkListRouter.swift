//
//  MarkListRouter.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 21.03.22.
//

import UIKit

class MarkListRouter: Router {
    var root: UIViewController
    
    required init(root: UIViewController) {
        self.root = root
    }
    
    func goToMarkInfo(markID: String) {
        let target = findViewController(storyboardName: "Marks", storyboardId: "showMark") as! ShowMarkViewController
        target.markID = markID
        root.navigationController?.pushViewController(target, animated: true)
    }
}
