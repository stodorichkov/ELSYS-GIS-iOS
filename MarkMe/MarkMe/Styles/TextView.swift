//
//  TextView.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 28.02.22.
//

import Foundation
import UIKit

class TextView: UITextView {
    override func layoutSubviews() {
        super.layoutSubviews()
        // border
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 5
        // background
        backgroundColor = UIColor.white
    }
}
