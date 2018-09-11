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
    func relayoutCollectionView()
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
    
    var keyPhoto: UIImage? {
        didSet {
            if keyPhoto != nil {
                DispatchQueue.main.async {
                    self.repositoryTitleImageView.image = self.keyPhoto
                    self.delegate?.relayoutCollectionView()
                }
            }
        }
    }
    var portraitPhoto: UIImage? {
        didSet {
            if portraitPhoto != nil {
                DispatchQueue.main.async {
                    self.repositoryStarterPortraitImageView.image = self.portraitPhoto
                }
            }
        }
    }
    
    var preview: ArtworkPreview! {
        didSet {
            repositoryTitleLabel.text = preview.title
            repositoryStarterNameLabel.text = preview.creatorName
            branchNumberLabel.text = String(preview.numberOfForks)
            starNumberLabel.text = String(preview.numberOfStars)
            self.repositoryStarterPortraitImageView.image = UIImage(named: "User")
        }
    }
    
    @IBAction func moreButtonTapped(_ sender: UIButton) {
        delegate?.moreButtonDidTapped(index: index)
    }
    
    @IBAction func starButtonTapped(_ sender: UIButton) {
        starButton.setImage(UIImage(named: "SelectedStarButton")!, for: .normal)
    }
    
}
