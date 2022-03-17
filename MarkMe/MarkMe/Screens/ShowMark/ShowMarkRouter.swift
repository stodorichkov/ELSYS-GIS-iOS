//
//  ShowMarkRouter.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 17.03.22.
//

import UIKit

class ShowMarkRouter: Router {
    var root: UIViewController
    
    required init(root: UIViewController) {
        self.root = root
    }
    
    func dismiss() {
        root.navigationController?.popViewController(animated: true)
    }
    
}
