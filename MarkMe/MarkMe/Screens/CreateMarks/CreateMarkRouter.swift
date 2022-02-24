//
//  CreateMarkRouter.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 24.02.22.
//

import Foundation
import UIKit

class CreateMarkRouter: Router {
    var root: UIViewController
    
    required init(root: UIViewController) {
        self.root = root
    }
    
    func dismiss() {
        root.navigationController?.popViewController(animated: true)
    }
}
