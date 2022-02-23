//
//  ViewController.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 2.01.22.
//

import UIKit
//import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet private var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewModel = MainViewModel(delegate: self)
        viewModel.makeLoad()
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

/*extension ViewController {
    func makeLoad() {
        var progress: Float = 0.0
        progressBar.progress = progress
        Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true, block: { [weak self] (timer) in
            progress += 0.1
            self?.progressBar.progress = progress
            if progress == 1 {
                timer.invalidate()
            }
        })
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] (timer) in
            Auth.auth().addStateDidChangeListener() { [weak self] (auth, user) in
                if user != nil {
                    self?.changeScreen(storyboardName: "Tabs", viewControllerId: "tabs", transition: .crossDissolve)
                }
                else {
                    self?.changeScreen(storyboardName: "Authentication", viewControllerId: "login", transition: .crossDissolve)
                }
            }
            
        })
    }
}*/

