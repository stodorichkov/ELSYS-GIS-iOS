//
//  ShowMarkVC.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 19.01.22.
//

import UIKit
import FirebaseStorageUI

class ShowMarkViewController: UIViewController {

    @IBOutlet private var markTitle: UILabel!
    @IBOutlet private var creator: UILabel!
    @IBOutlet private var type: UILabel!
    @IBOutlet private var markDescription: UITextView!
    @IBOutlet private var likes: UILabel!
    @IBOutlet private var image: UIImageView!
    
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private var solveButton: UIButton!
    
    private let viewModel =  ShowMarkViewModel()
    var markID: String?
    private var router: ShowMarkRouter?
    private var mark: Mark?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        router = ShowMarkRouter(root: self)
        setMark()
    }
}

// set data
extension ShowMarkViewController {
    func setMark() {
        viewModel.getMarkInfo(markID: markID) { [weak self] (mark) in
            guard let mark = mark else {
                self?.router?.dismiss()
                return
            }
            self?.mark = mark
            self?.setData()
            self?.setButtonsImage()
        }
    }
    
    func setData() {
        guard let mark = mark else {
            return
        }
        // set text information (title, description, type)
        markTitle.text = mark.title
        type.text = mark.type
        markDescription.text = mark.description
        
        // format like to replace 1000 with K
        var likeCount = String(mark.likes.count)
        if mark.likes.count >= 1000 {
            likeCount = String(mark.likes.count / 1000) + "K"
        }
        // set count of likes
        likes.text = likeCount
        
        // set creator
        viewModel.getCreatorName(creator: mark.creator) { [weak self] (creatorName) in
            self?.creator.text = creatorName
        }
        
        // get image
        guard let ref = viewModel.setImage(imgPath: mark.imgPath) else {
            return
        }
        image.sd_setImage(with: ref, placeholderImage: UIImage(systemName: "photo"))
    }
    
    func setButtonsImage() {
        guard let mark = mark else {
            return
        }
        
        // check is curent user like this mark
        if mark.likes.contains(viewModel.uid) {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        // check is curent user tag as solved this mark
        if mark.solved.contains(viewModel.uid) {
            solveButton.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        }
        else {
            solveButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        }
        
        // check mark satus
        switch mark.solved.count {
        case ..<5:
            solveButton.tintColor = .systemRed
        case 5..<10:
            solveButton.tintColor = .systemYellow
        case 10...:
            solveButton.tintColor = .systemGreen
        default:
            break
        }
    }
}

// buttons
extension ShowMarkViewController {
    @IBAction func backToHome(_ sender: UIButton) {
        router?.dismiss()
    }
    
    @IBAction func likeOrUnlike(_ sender: UIButton) {
        guard let mark = mark else {
            return
        }
        var likes = mark.likes
        if mark.likes.contains(viewModel.uid) {
            likes = likes.filter(){$0 != viewModel.uid}
        }
        else {
            likes.append(viewModel.uid)
        }
        viewModel.updateSet(markID: mark.id, arrayName: "likes", array: likes)
    }
    
    @IBAction func solveOrUnsolve(_ sender: UIButton) {
        guard let mark = mark else {
            return
        }
        var solved = mark.solved
        if mark.solved.contains(viewModel.uid) {
            solved = solved.filter(){$0 != viewModel.uid}
        }
        else {
            solved.append(viewModel.uid)
        }
        viewModel.updateSet(markID: mark.id, arrayName: "solved", array: solved)
    }
}
