//
//  CreateMarkVC.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 19.01.22.
//

import UIKit

class CreateMarkVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backToHome(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createNewMark(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}
