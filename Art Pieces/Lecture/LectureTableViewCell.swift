//
//  LectureTableViewCell.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/8/9.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

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
    
    override var frame: CGRect {
        didSet {
            var newFrame = frame
            newFrame.origin.x += 200
            newFrame.size.width -= 2 * 200
            super.frame = newFrame
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
