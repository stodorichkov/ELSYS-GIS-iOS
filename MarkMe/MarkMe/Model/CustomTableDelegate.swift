//
//  CustomTableDelegate.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 21.03.22.
//

import Foundation
protocol CustomTableDelegate {
    func reloadTable()
    func goToMarkInfo(markID: String)
}
