//
//  HomeVC.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 17.01.22.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var addButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.layer.cornerRadius = addButton.frame.width / 2
        addButton.layer.borderWidth = 3
        addButton.layer.borderColor = UIColor.white.cgColor

        // Do any additional setup after loading the view.
    }

}
