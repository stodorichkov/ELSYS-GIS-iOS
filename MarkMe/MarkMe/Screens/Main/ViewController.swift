//
//  ViewController.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 2.01.22.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let router = MainRouter(root: self)
        let viewModel = MainViewModel()
        viewModel.makeLoad() { result in
            router.goToNextScreen(storyboardName: result.storyboardName, storyboardId: result.storyboardId)
        }
    }
}
