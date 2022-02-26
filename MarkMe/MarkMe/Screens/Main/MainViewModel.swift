//
//  MainViewModel.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 20.02.22.
//

import Foundation
import FirebaseAuth

class MainViewModel {
    var mainViewModelDelegate: MainViewModelDelegate?
    
    init(delegate: MainViewModelDelegate) {
        self.mainViewModelDelegate = delegate
    }

    func makeLoad(completion: @escaping (ScreenInfo) -> ()) {
        var progress: Float = 0.0
        mainViewModelDelegate?.upadeteProgressBar(progress: progress)
        Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true, block: { (timer) in
            progress += 0.1
            self.mainViewModelDelegate?.upadeteProgressBar(progress: progress)
            if progress == 1 {
                timer.invalidate()
            }
        })
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
            Auth.auth().addStateDidChangeListener() { (auth, user) in
                if user != nil {
                    completion(ScreenInfo(storyboardName: "Tabs", storyboardId: "tabs"))
                }
                else {
                    completion(ScreenInfo(storyboardName: "Authentication", storyboardId: "login"))
                }
            }
        })
    }
}
