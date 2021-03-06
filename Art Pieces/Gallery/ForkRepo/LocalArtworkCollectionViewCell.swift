//
//  LocalArtworkCollectionViewCell.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/8/30.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit



class LocalArtworkCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var localArtworkImageView: UIImageView! {
        didSet {
            localArtworkImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var selectIndicatorImageView: UIImageView!
    @IBOutlet weak var artworkTitleLabel: UILabel!
    
    var forkPreview: ForkPreview? {
        didSet {
            artworkTitleLabel.text = forkPreview?.title
        }
    }
    var keyPhoto: UIImage! {
        didSet {
            localArtworkImageView.image = keyPhoto
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setSelected() {
        selectIndicatorImageView.image = UIImage(named: "SelectedSelectIndicator")!
        artworkTitleLabel.textColor = APTheme.purpleHighLightColor
    }
    
    func setDeselected() {
        selectIndicatorImageView.image = UIImage(named: "SelectIndicator")!
        artworkTitleLabel.textColor = APTheme.darkGreyColor
    }

}
