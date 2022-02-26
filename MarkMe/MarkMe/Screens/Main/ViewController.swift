//
//  ViewController.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 2.01.22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewModel = MainViewModel(delegate: self)
        let router = MainRouter(root: self)
        viewModel.makeLoad() { result in
            router.goToNextScreen(storyboardName: result.storyboardName, storyboardId: result.storyboardId)
        }
    }
}

extension ViewController: MainViewModelDelegate{
    func goToNextScreen(storyboardName: String, storyboardId: String) {
        let router = MainRouter(root: self)
        router.goToNextScreen(storyboardName: storyboardName, storyboardId: storyboardId)
    }
    
    func upadeteProgressBar(progress: Float) {
        progressBar.progress = progress
    }
    
    
}
