//
//  MainViewModel.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 20.02.22.
//

import Foundation
import FirebaseAuth

class MainViewModel {

    func makeLoad(completion: @escaping (ScreenInfo) -> ()) {
//        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
            Auth.auth().addStateDidChangeListener() { (auth, user) in
                if user != nil {
                    completion(ScreenInfo(storyboardName: "Tabs", storyboardId: "tabs"))
                }
                else {
                    completion(ScreenInfo(storyboardName: "Authentication", storyboardId: "login"))
                }
            }
        //})
    }
}
