//
//  RoundedButtonModel.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 15.02.22.
//

import Foundation
import UIKit

class RoundedButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 20
        layer.shadowColor = backgroundColor?.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 10
    }
}
