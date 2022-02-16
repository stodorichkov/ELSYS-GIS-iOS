//
//  HomeVC.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 17.01.22.
//

import UIKit

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func goToCreateMark(_ sender: UIButton) {
        navigateToScreen(storyboardName: "Marks", viewControllerId: "createMark")
    }
}
