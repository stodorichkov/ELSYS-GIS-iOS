//
//  MainViewModel.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 20.02.22.
//

import Foundation
import FirebaseAuth

class MainViewModel {

    func makeLoad(completion: @escaping (Bool) -> ()) {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
            Auth.auth().addStateDidChangeListener() { (auth, user) in
                if user != nil {
                    completion(true)
                }
                else {
                    completion(false)
                }
            }
        })
    }
}
