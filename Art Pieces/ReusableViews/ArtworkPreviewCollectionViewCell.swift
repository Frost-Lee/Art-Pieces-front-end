//
//  ArtworkPreviewCollectionViewCell.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/8/9.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

protocol ArtworkPreviewDelegate: class {
    func moreButtonDidTapped(index: Int)
}

struct ArtworkPreview {
    var uuid: UUID
    var keyPhotoPath: String
    var title: String
    var creatorName: String
    var creatorPortraitPath: String
    var numberOfForks: Int
    var numberOfStars: Int
}

class ArtworkPreviewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var repositoryTitleImageView: UIImageView! {
        didSet {
            repositoryTitleImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var repositoryTitleLabel: UILabel!
    @IBOutlet weak var repositoryStarterPortraitImageView: UIImageView!
    @IBOutlet weak var repositoryStarterNameLabel: UILabel!
    @IBOutlet weak var branchNumberLabel: UILabel!
    @IBOutlet weak var starNumberLabel: UILabel!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    weak var delegate: ArtworkPreviewDelegate?
    
    var index: Int = 0
    
    var preview: ArtworkPreview! {
        didSet {
            repositoryTitleImageView.image = DataManager.defaultManager.getImage(path: preview.keyPhotoPath)
            repositoryTitleLabel.text = preview.title
            repositoryStarterPortraitImageView.image = DataManager.defaultManager.getImage(path: preview.creatorPortraitPath)
            repositoryStarterNameLabel.text = preview.creatorName
            branchNumberLabel.text = String(preview.numberOfForks)
            starNumberLabel.text = String(preview.numberOfStars)
        }
    }
    
    @IBAction func moreButtonTapped(_ sender: UIButton) {
        delegate?.moreButtonDidTapped(index: index)
    }
    
    @IBAction func starButtonTapped(_ sender: UIButton) {
        starButton.setImage(UIImage(named: "SelectedStarButton")!, for: UIControl.State.normal)
    }
    
    func setTitleImage(to image: UIImage) {
        repositoryTitleImageView.image = image
        let widthHeightRatio = image.size.width / image.size.height
        let frame = repositoryTitleImageView.frame
        repositoryTitleImageView.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width,
                                                height: frame.width / widthHeightRatio)
        setNeedsLayout()
    }
    
}
