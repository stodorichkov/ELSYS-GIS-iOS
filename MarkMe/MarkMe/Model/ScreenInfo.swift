//
//  ScreenInfo.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 26.02.22.
//

import Foundation

struct ScreenInfo {
    var storyboardName: String
    var storyboardId: String
    
    init(storyboardName: String, storyboardId: String) {
        self.storyboardName = storyboardName
        self.storyboardId = storyboardId
    }
}
