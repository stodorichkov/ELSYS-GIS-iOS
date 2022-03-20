//
//  SubmitButtonModel.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 15.02.22.
//

import UIKit

class SubmitButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
        layer.backgroundColor = UIColor.systemRed.cgColor
        layer.shadowColor = UIColor.systemRed.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 15
    }
}
