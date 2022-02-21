//
//  MainViewModel.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 20.02.22.
//

import Foundation
import UIKit
import FirebaseAuth

class MainViewModel {
    var progressBar: UIProgressView
    var router: MainRouter
    
    init(root: UIViewController, progressBar: UIProgressView) {
        self.router = MainRouter(root: root)    
        self.progressBar = progressBar
    }

    func makeLoad() {
        var progress: Float = 0.0
        print(progressBar.progress)
        progressBar.progress = progress
        print(progressBar.progress)
        Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true, block: { [self] (timer) in
            progress += 0.1
            self.progressBar.progress = progress
            if progress == 1 {
                timer.invalidate()
            }
        })
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] (timer) in
            Auth.auth().addStateDidChangeListener() { [weak self] (auth, user) in
                if user != nil {
                    self?.router.goToNextScreen(storyboardName: "Tabs", storyboardId: "tabs")
                }
                else {
                    self?.router.goToNextScreen(storyboardName: "Authentication", storyboardId: "login")
                }
            }
        })
    }
}
