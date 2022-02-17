//
//  CircleButton.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 16.02.22.
//

import Foundation
import UIKit

class CircleButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2
        layer.borderWidth = 3
        layer.borderColor = UIColor.white.cgColor
    }
}
