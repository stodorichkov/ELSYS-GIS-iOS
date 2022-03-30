//
//  CustomTableDelegate.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 21.03.22.
//

import Foundation
protocol MarkActionsDelegate {
    func reloadTable()
    func goToMarkInfo(markID: String)
    func goToEdit(mark: Mark?)
    func deleteMark(mark: Mark?)
}
