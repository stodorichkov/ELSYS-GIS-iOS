//
//  Router.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 20.02.22.
//

import UIKit

protocol Router {
    var root: UIViewController { get } 
    
    init(root: UIViewController)
}

extension Router {
    func findViewController(storyboardName: String, storyboardId: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: storyboardId)
    }
    
    func presentTarget (target: UIViewController, transition: UIModalTransitionStyle) {
        target.modalPresentationStyle = .fullScreen
        target.modalTransitionStyle = transition
        root.present(target, animated: true)
    }
}
