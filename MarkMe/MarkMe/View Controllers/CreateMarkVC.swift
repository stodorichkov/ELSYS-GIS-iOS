//
//  CreateMarkVC.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 19.01.22.
//

import UIKit

class CreateMarkVC: UIViewController {

    @IBOutlet weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 5
    }
    @IBAction func backToHome(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createNewMark(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}
