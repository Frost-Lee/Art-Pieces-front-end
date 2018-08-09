//
//  GalleryCollectionViewCell.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/8/9.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var repositoryTitleImageView: UIImageView!
    @IBOutlet weak var repositoryTitleLabel: UILabel!
    @IBOutlet weak var repositoryStarterPortraitImageView: UIImageView!
    @IBOutlet weak var repositoryStarterNameLabel: UILabel!
    @IBOutlet weak var branchNumberLabel: UILabel!
    @IBOutlet weak var starNumberLabel: UILabel!
    @IBOutlet weak var starButton: UIButton!
    
    var index: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func cellSelectionButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func starButtonTapped(_ sender: UIButton) {
    }
    
}
