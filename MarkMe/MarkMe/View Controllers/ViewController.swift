//
//  ViewController.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 2.01.22.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeLoad()
    }
}
extension ViewController {
    func makeLoad() {
        var progress: Float = 0.0
        progressBar.progress = progress
        Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true, block: { (timer) in
            progress += 0.1
            self.progressBar.progress = progress
            if progress == 1 {
                timer.invalidate()
            }
        })
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
            self.changeScreen(storyboardName: "Authentication", viewControllerId: "authentication", transition: .crossDissolve)
        })
    }
}

