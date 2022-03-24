//
//  EditMarkRouter.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 22.03.22.
//

import UIKit

class EditMarkRouter: Router {
    var root: UIViewController
    
    required init(root: UIViewController) {
        self.root = root
    }
    
    func dismiss() {
        root.navigationController?.popViewController(animated: true)
    }
}
