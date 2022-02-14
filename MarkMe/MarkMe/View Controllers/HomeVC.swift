//
//  HomeVC.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 17.01.22.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet private var addButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.layer.cornerRadius = addButton.frame.width / 2
        addButton.layer.borderWidth = 3
        addButton.layer.borderColor = UIColor.white.cgColor
    }

    @IBAction func goToCreateMark(_ sender: UIButton) {
        navigateToScreen(storyboardName: "Marks", viewControllerId: "createMark")
    }
}
