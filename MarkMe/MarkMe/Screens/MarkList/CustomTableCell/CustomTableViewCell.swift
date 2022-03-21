//
//  CustomTableViewCell.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 21.03.22.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet private var titleButton: UIButton!
    
    static let identifier = "CustomTableViewCell"
    var delegate: CustomTableDelegate?
    var mark: Mark?
    
    static func nib() -> UINib {
        return UINib(nibName: "CustomTableViewCell", bundle: nil)
    }
    
    func configure(mark: Mark) {
        self.mark = mark
        titleButton.setTitle(mark.title, for: .normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension CustomTableViewCell {
    @IBAction func titleDidTap() {
        guard let id = mark?.id else {
            return
        }
        delegate?.goToMarkInfo(markID: id)
    }
    
    @IBAction func pencilDidTap() {
        
    }
    
    @IBAction func trashDidTap() {
        
    }
}
