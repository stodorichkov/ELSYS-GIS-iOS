//
//  CustomSearch.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 6.03.22.
//

import UIKit

class CustomSearch: UIStackView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 2
    }
}
