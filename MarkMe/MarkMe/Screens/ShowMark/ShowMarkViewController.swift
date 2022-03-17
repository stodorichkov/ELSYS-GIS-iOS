//
//  ShowMarkVC.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 19.01.22.
//

import UIKit
import FirebaseStorage
import FirebaseStorageUI

class ShowMarkViewController: UIViewController {

    @IBOutlet private var markTitle: UILabel!
    @IBOutlet private var creator: UILabel!
    @IBOutlet private var type: UILabel!
    @IBOutlet private var markDescription: UITextView!
    @IBOutlet private var likes: UILabel!
    @IBOutlet private var image: UIImageView!
    
    private let viewModel =  ShowMarkViewModel()
    var markID: String?
    private var router: ShowMarkRouter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        router = ShowMarkRouter(root: self)
        setData()
    }
    
    func setData() {
        viewModel.getMarkInfo(markID: markID) { [weak self] (mark) in
            guard let mark = mark else {
                self?.router?.dismiss()
                return
            }
            // get text information (title, description, type)
            self?.markTitle.text = mark.title
            self?.type.text = mark.type
            self?.markDescription.text = mark.description
            // get count of likes
            self?.likes.text = String(mark.likes.count)
            // get creator
            self?.viewModel.getCreatorName(creator: mark.creator) { (creatorName) in
                self?.creator.text = creatorName
            }
            // get image
            if mark.imgPath != ""{
                let storage = Storage.storage()
                let ref = storage.reference(forURL: mark.imgPath)
                self?.image.sd_setImage(with: ref, placeholderImage: UIImage(systemName: "photo"))
            }
        }
    }
    
    @IBAction func backToHome(_ sender: UIButton) {
        router?.dismiss()
    }
}
