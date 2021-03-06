//
//  LectureTableViewCell.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/8/9.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

protocol LectureTableViewCellDelegate: class {
    func downloadButtonDidTapped(at index: Int)
}

class LectureTableViewCell: UITableViewCell {
    
    @IBOutlet weak var borderView: UIView! {
        didSet {
            borderView.layer.cornerRadius = 3
            borderView.layer.borderWidth = 1
            borderView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var lectureTitleImageView: UIImageView! {
        didSet {
            lectureTitleImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var lectureTitleLabel: UILabel!
    @IBOutlet weak var lectureStepNumberLabel: UILabel!
    @IBOutlet weak var lectureStarterPortraitImageView: UIImageView!
    @IBOutlet weak var lectureStarterNameLabel: UILabel!
    @IBOutlet weak var watchNumberLabel: UILabel!
    @IBOutlet weak var starNumberLabel: UILabel!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton! {
        didSet {
            downloadButton.layer.cornerRadius = 15
        }
    }
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    weak var delegate: LectureTableViewCellDelegate?
    
    var index: Int!
    
    var lecturePreview: LecturePreview? {
        didSet {
            if lecturePreview != nil {
                lectureTitleLabel.text = lecturePreview!.title
                lectureStepNumberLabel.text = String(lecturePreview!.numberOfSteps) + " steps"
                starNumberLabel.text = String(lecturePreview!.numberOfStars)
                lectureStarterNameLabel.text = lecturePreview!.creatorName
            }
        }
    }
    var keyPhoto: UIImage? {
        didSet {
            DispatchQueue.main.async {
                self.lectureTitleImageView.image = self.keyPhoto
            }
        }
    }
    var portraitPhoto: UIImage? {
        didSet {
            DispatchQueue.main.async {
                self.lectureStarterPortraitImageView.image = self.portraitPhoto
            }
        }
    }
    
    override var frame: CGRect {
        didSet {
            var newFrame = frame
            var sideOffset = UIScreen.main.bounds.width * 0.15
            if UIScreen.main.bounds.width - 2 * sideOffset < 655 {
                sideOffset = (UIScreen.main.bounds.width - 655) / 2
            }
            newFrame.origin.x += sideOffset
            newFrame.size.width -= 2 * sideOffset
            super.frame = newFrame
        }
    }
    
    @IBAction func downloadButtonTapped(_ sender: UIButton) {
        startAnimating()
        delegate?.downloadButtonDidTapped(at: index)
    }
    
    func startAnimating() {
        downloadButton.isHidden = true
        spinner.startAnimating()
    }
    
    func stopAnimating() {
        downloadButton.isHidden = false
        spinner.stopAnimating()
    }
    
}
