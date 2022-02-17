//
//  TextFieldModel.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 15.02.22.
//

import Foundation
import UIKit
import AVFoundation

class TextField: UITextField {
    override func layoutSubviews() {
        super.layoutSubviews()
        // border
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 5
        // placeholder
        attributedPlaceholder = NSAttributedString(string: placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        // background
        backgroundColor = UIColor.white
        // clear button
        clearButtonMode = .whileEditing
        for view in subviews {
            if let button = view as? UIButton {
                button.setImage(button.image(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
                button.tintColor = .link
            }
        }
    }
}
