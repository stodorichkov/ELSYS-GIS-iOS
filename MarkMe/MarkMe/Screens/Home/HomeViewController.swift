//
//  HomeVC.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 17.01.22.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func goToCreateMark(_ sender: UIButton) {
        let router = HomeRouter(root: self) 
        router.goToNextScreen(storyboardName: "Marks", storyboardId: "createMark")
    }
}
