//
//  MainViewModelDelegate.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 23.02.22.
//

import Foundation
protocol MainViewModelDelegate {
    func upadeteProgressBar(progress: Float)
    func goToNextScreen(storyboardName: String, storyboardId: String)
}
